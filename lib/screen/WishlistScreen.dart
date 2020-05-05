import 'package:flutter/material.dart';
import 'package:grocery/db/DatabaseHelper.dart';
import 'package:grocery/modal/Cart.dart';
import 'package:grocery/modal/Wishlist.dart';
import 'package:grocery/util/DependencyInjection.dart';
import 'package:grocery/util/String.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  DatabaseHelper _databaseHelper;

  List<Wishlist> _wishlist;
  List<Cart> _cartList;

  bool _isLoadingWishlist;
  bool _isLoadingCart;

  void _getCartList() async {
    var cartList = await _databaseHelper.getCartList();
    setState(() {
      this._cartList = cartList;
      _isLoadingCart = false;
    });
  }

  void _getWishlist() async {
    List<Wishlist> result = await _databaseHelper.getWishlist();
    setState(() {
      _wishlist = result;
      _isLoadingWishlist = false;
    });
  }

  void _removeWishlist(int index) async {
    var result = await _databaseHelper.removeFromWishlist(_wishlist[index].id);
    setState(() {
      _wishlist.removeAt(index);
    });
  }

  void _addRemoveCart(int index, String prvQ, int nextQ) async {
    int quant = int.parse(prvQ);
    if (quant == 0) {
      Cart cart = Cart(
          id: _wishlist[index].id,
          title: _wishlist[index].title,
          quantity: _wishlist[index].quantity,
          price: _wishlist[index].price,
          image: _wishlist[index].image,
          q: "1");
      var result = await _databaseHelper.insertCartItem(cart);
      _getCartList();
    } else {
      quant += nextQ;
      Cart cart = Cart(
          id: _wishlist[index].id,
          title: _wishlist[index].title,
          quantity: _wishlist[index].quantity,
          price: _wishlist[index].price,
          image: _wishlist[index].image,
          q: quant.toString());
      if (quant == 0) {
        var result = await _databaseHelper.deleteCartItem(cart.id);
      } else {
        var result = await _databaseHelper.updateCartItem(cart);
      }
      _getCartList();
    }
  }

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _isLoadingWishlist = true;
    _isLoadingCart = true;
    _getWishlist();
    _getCartList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.only(top: 32.0, bottom: 22.0),
          child: Text(
            TITLE_WISHLIST,
            style: TextStyle(color: Colors.white, fontSize: 22.0),
          ),
        ),
      ),
      body: _isLoadingWishlist || _isLoadingCart
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _wishlist.length == null || _wishlist.length == 0
              ? Center(
                  child: Text(
                    TEXT_WISHLIST_EMPTY,
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 16.0),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(bottom: 64.0),
                  itemCount: _wishlist.length,
                  itemBuilder: (context, index) {
                    return _getWishlistItem(index);
                  },
                ),
    );
  }

  Widget _getWishlistItem(int index) {
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
                        ? NetworkImage(_wishlist[index].image)
                        : AssetImage(_wishlist[index].image),
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
                      _wishlist[index].quantity,
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
                        _wishlist[index].title,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        RS + _wishlist[index].price,
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
                            GestureDetector(
                              child: Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              onTap: () {
                                _removeWishlist(index);
                              },
                            ),
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
    for (int i = 0; i < _cartList.length; i++) {
      if (_cartList[i].id == _wishlist[index].id) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.remove_circle_outline,
                color: Colors.orangeAccent,
              ),
              onPressed: () {
                _addRemoveCart(index, _cartList[i].q, -1);
              },
            ),
            Text(
              _cartList[i].q,
              style: TextStyle(
                  color: Colors.orangeAccent, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                color: Colors.orangeAccent,
              ),
              onPressed: () {
                _addRemoveCart(index, _cartList[i].q, 1);
              },
            ),
          ],
        );
      }
    }

    return MaterialButton(
      onPressed: () {
        _addRemoveCart(index, "0", 0);
      },
      color: Colors.orangeAccent,
      child: Text(
        TEXT_ADD_TO_CART,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
    );
  }
}
