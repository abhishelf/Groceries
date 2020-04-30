import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocery/modal/Grocery.dart';
import 'package:grocery/util/String.dart';

class HomeScreen extends StatefulWidget {
  final List<Grocery> grocery;

  HomeScreen({Key key, this.grocery}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Grocery> _groceryList;

  @override
  void initState() {
    super.initState();
    _groceryList = widget.grocery;
  }

  void _handleItemClick(int index){

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
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.sort,
                color: Colors.white,
              ))
        ],
      ),
      body: ListView.builder(
        itemCount: _groceryList.length,
        itemBuilder: (context, index) {
          return _getGroceryListItem(index);
        },
      ),
    );
  }

  Widget _getGroceryListItem(int index) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                        _groceryList[index].quantity,
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
                        _groceryList[index].title,
                        style: TextStyle(color: Colors.black, fontSize: 18.0),
                      ),
                      Text(
                        RS+_groceryList[index].price,
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
            Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Divider(
                color: Colors.grey,
                thickness: 0.4,
              ),
            )
          ],
        ),
      ),
      onTap: (){
        _handleItemClick(index);
      },
    );
  }
}
