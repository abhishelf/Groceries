import 'package:flutter/material.dart';
import 'package:grocery/modal/Cart.dart';
import 'package:grocery/modal/Profile.dart';
import 'package:grocery/util/String.dart';

class CartScreen extends StatefulWidget {
  final Profile profile;

  CartScreen({Key key,this.profile}):super(key:key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Cart> _cartList;

  @override
  void initState() {
    super.initState();
    _cartList = widget.profile.cartList;
  }

  String _getItemPrice(int index){
    int q = int.parse(_cartList[index].cartQ);
    int price = int.parse(_cartList[index].price);
    return (q*price).toString();
  }

  String _getTotalPrice(){
    int total = 0;
    for(int i=0;i<_cartList.length;i++){
      int q = int.parse(_cartList[i].cartQ);
      int price = int.parse(_cartList[i].price);
      total += (q*price);
    }
    return total.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.only(top: 32.0,bottom: 22.0),
          child: Text(
            "Cart",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.0
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(bottom: 64.0),
        itemCount: _cartList.length,
        itemBuilder: (context, index){
          return _getCartListItem(index);
        },
      ),
      bottomSheet: BottomSheet(
        backgroundColor: Colors.black12,
        enableDrag: false,
        onClosing: (){},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(26.0),
              topRight: Radius.circular(26.0)),
        ),
        builder: (context){
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 32.0,vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Total : "+RS+_getTotalPrice(),
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      PROCEED_CART,
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,color: Colors.green,)
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _getCartListItem(int index){
    return GestureDetector(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.blueGrey,
                      child: Image(
                        image: AssetImage("images/apple.jpg"),
                      ),
                    ),
                    Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.8),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      child: Text(
                        _cartList[index].cartQ,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(left: 8.0, right: 8.0)),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        _cartList[index].title,
                        style: TextStyle(color: Colors.black, fontSize: 18.0),
                      ),
                      Text(
                        RS+_getItemPrice(index),
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
