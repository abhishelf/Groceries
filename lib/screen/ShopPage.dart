import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/db/DatabaseHelper.dart';
import 'package:grocery/modal/Cart.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopPage extends StatefulWidget {
  final List<Cart> cart;

  ShopPage({Key key, this.cart}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  static final _formKey = GlobalKey<FormState>();
  static TextEditingController _name = TextEditingController();
  static TextEditingController _phone = TextEditingController();
  static TextEditingController _address = TextEditingController();

  int _currentIndex = 0;

  static bool _isLoading = false;
  bool _isComplete = false;
  bool _isError = false;

  List<Step> step;

  next() {
    if (_currentIndex == 0) {
      if (_formKey.currentState.validate()) {
        goTo(_currentIndex + 1);
      }
    } else if (_currentIndex == 1) {
      goTo(_currentIndex + 1);
    } else if (_currentIndex == 2) {
      setState(() {
        _isLoading = true;
        placeOrder();
      });
    }
  }

  cancel() {
    if (_currentIndex > 0) {
      goTo(_currentIndex - 1);
    } else {
      Navigator.pop(context);
    }
  }

  goTo(int step) {
    setState(() => _currentIndex = step);
  }

  placeOrder() async {
    List<String> cart = List();
    for (int i = 0; i < widget.cart.length; i++) {
      String str = widget.cart[i].title +
          "@" +
          widget.cart[i].price +
          "@" +
          widget.cart[i].q +
          "@" +
          widget.cart[i].quantity +
          "@" +
          widget.cart[i].image;
      cart.add(str);
    }

    String jsonCart = jsonEncode(cart);
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
      'cart': jsonCart,
      'date': formattedDate,
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
      });
    });
  }

  deleteCart() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    var result = await databaseHelper.deleteCart();
  }

  @override
  void initState() {
    super.initState();
    step = [
      Step(
        title: Text("Info"),
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
                        decoration: InputDecoration(hintText: "Name"),
                        keyboardType: TextInputType.text,
                        controller: _name,
                        enabled: !_isLoading,
                        validator: (value) {
                          if (value == null || value == "")
                            return "Enter Your Name";
                          return null;
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      TextFormField(
                        autofocus: false,
                        decoration: InputDecoration(hintText: "Phone"),
                        keyboardType: TextInputType.phone,
                        controller: _phone,
                        enabled: !_isLoading,
                        validator: (value) {
                          if (value == null || value == "")
                            return "Enter Your Contact Number";
                          if (value.length != 10)
                            return "Enter Valid Contact Number";
                          return null;
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      TextFormField(
                        autofocus: false,
                        decoration:
                            InputDecoration(hintText: "Shipping Address"),
                        keyboardType: TextInputType.text,
                        controller: _address,
                        maxLines: 5,
                        enabled: !_isLoading,
                        validator: (value) {
                          if (value == null || value == "")
                            return "Enter Your Shipping Address";
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
        title: Text("Payment"),
        isActive: true,
        state: StepState.indexed,
        content: RadioListTile(
          title: Text(
            "Cash On Delivery",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          activeColor: Colors.blue,
          selected: true,
        ),
      ),
      Step(
        title: Text("Place Order"),
        isActive: true,
        state: StepState.indexed,
        content: Container(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Place Order",
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
                "Sorry For Inconvenience\n Error While Placing Order!\nYou can continue with your cart",
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
                "Placing Your Order",
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
                Text(
                  "Order Placed",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold),
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
        ),
      ),
    );
  }
}
