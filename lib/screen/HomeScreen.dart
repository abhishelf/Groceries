import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:aaharpurti/db/DatabaseHelper.dart';
import 'package:aaharpurti/modal/Cart.dart';
import 'package:aaharpurti/modal/Grocery.dart';
import 'package:aaharpurti/modal/Wishlist.dart';
import 'package:aaharpurti/util/DependencyInjection.dart';
import 'package:aaharpurti/util/String.dart';

class HomeScreen extends StatefulWidget {
  final List<Grocery> grocery;

  HomeScreen({Key key, this.grocery}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper _databaseHelper;

  List<Grocery> _groceryList;
  List<Cart> _cartList;
  List<Wishlist> _wishlist;

  bool _isLoadingCart;
  bool _isLoadingWish;

  void _addRemoveWishlist(Grocery grocery) async {
    try {
      bool result = await _databaseHelper.getWishlistById(grocery.id);
      if (result) {
        await _databaseHelper.removeFromWishlist(grocery.id);
      } else {
        Wishlist wishlist = Wishlist(
            id: grocery.id,
            title: grocery.title,
            image: grocery.image,
            price: grocery.price,
            quantity: grocery.price);
        await _databaseHelper.addToWishlist(wishlist);
      }
    } catch (error) {
      print(error);
    }

    _getWishlist();
  }

  void _addRemoveCart(int index, String prvQ, int nextQ) async {
    int quant = int.parse(prvQ);
    if (quant == 0) {
      Cart cart = Cart(
          id: _groceryList[index].id,
          title: _groceryList[index].title,
          quantity: _groceryList[index].quantity,
          price: _groceryList[index].price,
          image: _groceryList[index].image,
          q: "1");
      var result = await _databaseHelper.insertCartItem(cart);
      _getCartList();
    } else {
      quant += nextQ;
      Cart cart = Cart(
          id: _groceryList[index].id,
          title: _groceryList[index].title,
          quantity: _groceryList[index].quantity,
          price: _groceryList[index].price,
          image: _groceryList[index].image,
          q: quant.toString());
      if (quant == 0) {
        var result = await _databaseHelper.deleteCartItem(cart.id);
      } else {
        var result = await _databaseHelper.updateCartItem(cart);
      }
      _getCartList();
    }
  }

  void _getCartList() async {
    var cartList = await _databaseHelper.getCartList();
    setState(() {
      this._cartList = cartList;
      _isLoadingCart = false;
    });
  }

  void _getWishlist() async {
    var wishlist = await _databaseHelper.getWishlist();
    setState(() {
      this._wishlist = wishlist;
      _isLoadingWish = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _groceryList = widget.grocery;
    _databaseHelper = DatabaseHelper();
    _isLoadingCart = true;
    _isLoadingWish = true;
    _getCartList();
    _getWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          APP_TITLE,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: _isLoadingCart || _isLoadingWish
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _groceryList.length,
              itemBuilder: (context, index) {
                return _getGroceryListItem(index);
              },
            ),
    );
  }

  Widget _getGroceryListItem(int index) {
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
                        ? NetworkImage(_groceryList[index].image)
                        : AssetImage(_groceryList[index].image),
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
                      _groceryList[index].quantity,
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
                        _groceryList[index].title,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        RS + _groceryList[index].price,
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
                              child: _getWishListIcon(index),
                              onTap: () {
                                _addRemoveWishlist(_groceryList[index]);
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

  Widget _getWishListIcon(int index) {
    if (_wishlist == null) {
      return Icon(
        Icons.favorite_border,
        color: Colors.green,
      );
    }

    for (int i = 0; i < _wishlist.length; i++) {
      if (_wishlist[i].id == _groceryList[index].id) {
        return Icon(
          Icons.favorite,
          color: Colors.red,
        );
      }
    }

    return Icon(
      Icons.favorite_border,
      color: Colors.green,
    );
  }

  Widget _getCartLayout(int index) {
    for (int i = 0; i < _cartList.length; i++) {
      if (_cartList[i].id == _groceryList[index].id) {
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
