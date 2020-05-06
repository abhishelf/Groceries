import 'package:flutter/material.dart';
import 'package:grocery/db/DatabaseHelper.dart';
import 'package:grocery/modal/Cart.dart';
import 'package:grocery/util/DependencyInjection.dart';
import 'package:grocery/util/MyNavigator.dart';
import 'package:grocery/util/String.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DatabaseHelper _databaseHelper;

  List<Cart> _cartList;
  bool _isLoadingCart;

  void _getCartList() async {
    var cartList = await _databaseHelper.getCartList();
    setState(() {
      this._cartList = cartList;
      _isLoadingCart = false;
    });
  }

  void _addRemoveCart(int index, int nextQ) async {
    int quant = int.parse(_cartList[index].q);
    quant += nextQ;
    if (quant == 0) {
      var result = await _databaseHelper.deleteCartItem(_cartList[index].id);
      setState(() {
        _cartList.removeAt(index);
      });
    } else {
      _cartList[index].q = quant.toString();
      var result = await _databaseHelper.updateCartItem(_cartList[index]);
      setState(() {
        _cartList[index] = _cartList[index];
      });
    }
  }

  void _continueShop(context) {
    MyNavigator.goToShopPage(context, _cartList);
  }

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _isLoadingCart = true;
    _getCartList();
  }

  String _getItemPrice(int index) {
    int q = int.parse(_cartList[index].q);
    int price = int.parse(_cartList[index].price);
    return (q * price).toString();
  }

  String _getTotalPrice() {
    int total = 0;
    if (_cartList == null) return total.toString();
    for (int i = 0; i < _cartList.length; i++) {
      int q = int.parse(_cartList[i].q);
      int price = int.parse(_cartList[i].price);
      total += (q * price);
    }
    return total.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.only(top: 32.0, bottom: 22.0),
          child: Text(
            TITLE_CART,
            style: TextStyle(color: Colors.white, fontSize: 22.0),
          ),
        ),
      ),
      body: _isLoadingCart
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _cartList.length == null || _cartList.length == 0
              ? Center(
                  child: Text(
                    TEXT_CART_EMPTY,
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 16.0),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(bottom: 64.0),
                  itemCount: _cartList.length,
                  itemBuilder: (context, index) {
                    return _getCartListItem(index);
                  },
                ),
      bottomSheet: BottomSheet(
        backgroundColor: Colors.black12,
        enableDrag: false,
        onClosing: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(26.0), topRight: Radius.circular(26.0)),
        ),
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  TOTAL + RS + _getTotalPrice(),
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                GestureDetector(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(
                            TEXT_PROCEED_CART,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      _continueShop(context);
                    }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _getCartListItem(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: Injector.getFlavor() == Flavor.PROD
                        ? NetworkImage(_cartList[index].image)
                        : AssetImage(_cartList[index].image),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.8),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    child: Text(
                      _cartList[index].quantity,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(left: 16.0)),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _cartList[index].title,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        TOTAL + RS + _getItemPrice(index),
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 35.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            _getCartLayout(index),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
          thickness: 0.4,
        )
      ],
    );
  }

  Widget _getCartLayout(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.remove_circle_outline,
            color: Colors.orangeAccent,
          ),
          onPressed: () {
            _addRemoveCart(index, -1);
          },
        ),
        Text(
          _cartList[index].q,
          style: TextStyle(
              color: Colors.orangeAccent, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(
            Icons.add_circle_outline,
            color: Colors.orangeAccent,
          ),
          onPressed: () {
            _addRemoveCart(index, 1);
          },
        ),
      ],
    );
  }
}
