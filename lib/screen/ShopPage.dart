import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/db/DatabaseHelper.dart';
import 'package:grocery/modal/Cart.dart';
import 'package:grocery/util/String.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopPage extends StatefulWidget {
  final List<Cart> cart;

  ShopPage({Key key, this.cart}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  Razorpay _razorpay;

  static final _formKey = GlobalKey<FormState>();
  static TextEditingController _name = TextEditingController();
  static TextEditingController _phone = TextEditingController();
  static TextEditingController _address = TextEditingController();

  static bool _isLoading = false;
  bool _isComplete = false;
  bool _isError = false;
  bool _isOnlinePay = false;

  int _currentIndex = 0;
  int _priceToPay = 0;

  List<String> _cart = List();
  List<Step> step;

  String _errorMsg = "Order Not Placed";
  String _paymentId = "";

  next() {
    if (_currentIndex == 0) {
      if (_formKey.currentState.validate()) {
        goTo(_currentIndex + 1);
      }
    } else if (_currentIndex == 1) {
      _isOnlinePay = true;
      goTo(_currentIndex + 1);
    } else if (_currentIndex == 2) {
      setState(() {
        _isLoading = true;
        placeOrder();
      });
    }
  }

  cancel() {
    if(_currentIndex == 1){
      _isOnlinePay = false;
      goTo(_currentIndex+1);
    } else if (_currentIndex > 0) {
      goTo(_currentIndex - 1);
    } else {
      Navigator.pop(context);
    }
  }

  goTo(int step) {
    setState(() => _currentIndex = step);
  }

  String _getTotalPrice() {
    int total = 0;
    if (widget.cart == null) return total.toString();
    for (int i = 0; i < widget.cart.length; i++) {
      int q = int.parse(widget.cart[i].q);
      int price = int.parse(widget.cart[i].price);
      total += (q * price);
    }
    _priceToPay = total;
    return total.toString();
  }

  placeOrder() async {
    for (int i = 0; i < widget.cart.length; i++) {
      String str = widget.cart[i].title +
          "@" +
          _getTotalPrice() +
          "@" +
          widget.cart[i].q +
          "@" +
          widget.cart[i].quantity +
          "@" +
          widget.cart[i].image;
      _cart.add(str);
    }
    
    if(_isOnlinePay){
      _onlinePayment();
    }else{
      _setValue();
    }
  }
  
  _setValue() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String email = pref.getString("EMAIL");
    String datePostfix = DateTime.now().millisecondsSinceEpoch.toString();

    var now = DateTime.now();
    var formatter = DateFormat('dd/MM/yyyy');
    String formattedDate = formatter.format(now);
    Firestore.instance
        .collection("orders")
        .document(email + "#" + datePostfix)
        .setData({
      'name': _name.text,
      'phone': _phone.text,
      'address': _address.text,
      'cart': _cart,
      'date': formattedDate,
      'payment': _paymentId,
      'status': '0',
    }).then((_){
      setState(() {
        _isLoading = false;
        _isComplete = true;
        deleteCart();
      });
    }).catchError((_){
      setState(() {
        _isError = true;
        _isLoading = false;
        _isComplete = true;
      });
    });
  }

  deleteCart() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    var result = await databaseHelper.deleteCart();
  }

  void _onlinePayment(){
    var options = {
      'key': TEST_KEY_ID,
      'amount': _priceToPay*100,
      'name': APP_TITLE,
      'description': TEXT_PAYMENT_DESCRIPTION,
      'prefill': {
        'name': _name.text,
        'contact': "+91"+_phone.text,
      }
    };

   try{
     _razorpay.open(options);
   }catch(_){
     setState(() {
       _isError = true;
       _isLoading = false;
       _isComplete = true;
     });
   }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _paymentId = response.paymentId;
    _setValue();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _errorMsg = response.message;
    setState(() {
      _isError = true;
      _isLoading = false;
      _isComplete = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    step = [
      Step(
        title: Text(STEP1_TITLE),
        isActive: true,
        state: StepState.indexed,
        content: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Theme(
                data: ThemeData(
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    filled: true,
                    fillColor: Colors.white70,
                    labelStyle: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.only(bottom: 48.0, top: 16.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        autofocus: false,
                        decoration: InputDecoration(hintText: HINT_NAME),
                        keyboardType: TextInputType.text,
                        controller: _name,
                        enabled: !_isLoading,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return ERROR_VALID;
                          return null;
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      TextFormField(
                        autofocus: false,
                        decoration: InputDecoration(hintText: HINT_PHONE),
                        keyboardType: TextInputType.phone,
                        controller: _phone,
                        enabled: !_isLoading,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return ERROR_VALID;
                          if (value.length != 10)
                            return ERROR_VALID;
                          return null;
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      TextFormField(
                        autofocus: false,
                        decoration:
                            InputDecoration(hintText: HINT_ADDRESS),
                        keyboardType: TextInputType.text,
                        controller: _address,
                        maxLines: 5,
                        enabled: !_isLoading,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return ERROR_VALID;
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Step(
        title: Text(STEP2_TITLE),
        isActive: true,
        state: StepState.indexed,
        content: Container(),
      ),
      Step(
        title: Text(STEP3_TITLE),
        isActive: true,
        state: StepState.indexed,
        content: Container(),
      ),
    ];

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          TITLE_ORDER_PLACE,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: _isError ? Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                _errorMsg.isEmpty ? ERROR_ORDER : _errorMsg,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ):_isLoading
            ? Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              CircularProgressIndicator(),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
              ),
              Text(
                TEXT_ORDER_PLACING,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        )
            : _isComplete
            ? Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset("images/bg_placed.png"),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 24,
                  child: Icon(
                    Icons.done,
                    color: Colors.green,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    TEXT_ORDER_PLACED,
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    (_paymentId.isEmpty ? ".":"Keep It For Reference : "+_paymentId),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )
          ],
        )
            : Stepper(
          steps: step,
          currentStep: _currentIndex,
          onStepContinue: next,
          onStepTapped: (step) {
            if (step < _currentIndex) goTo(step);
          },
          onStepCancel: cancel,
          physics: ClampingScrollPhysics(),
          controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
            return Row(
              children: <Widget>[
                MaterialButton(
                  onPressed: onStepContinue,
                  color: Colors.blue,
                  child: _currentIndex != 1 ? Text("Continue",style: TextStyle(color: Colors.white),) : Text("Online",style: TextStyle(color: Colors.white),),
                ),
                Padding(padding: EdgeInsets.only(right: 16.0),),
                MaterialButton(
                  onPressed: onStepCancel,
                  color:_currentIndex != 1?Colors.white: Colors.blue,
                  child: _currentIndex != 1 ? Text("Cancel") : Text("Cash On Delivery",style: TextStyle(color: Colors.white),),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }
}
