import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:grocery/modal/Grocery.dart';
import 'package:grocery/screen/CartScreen.dart';
import 'package:grocery/screen/HistoryPage.dart';
import 'package:grocery/screen/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'WishlistScreen.dart';

class HomePage extends StatefulWidget {
  final List<Grocery> grocery;

  HomePage({Key key, this.grocery}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _bottomNavigationKey = GlobalKey();
  final PageStorageBucket bucket = PageStorageBucket();

  List<Widget> pageList;
  int _currentPage = 0;

  void _onBottomNavItemTap(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  void initState() {
    super.initState();
    pageList = [
      HomeScreen(grocery: widget.grocery),
      WishlistScreen(),
      CartScreen(),
      HistoryPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 50.0,
        items: <Widget>[
          Icon(
            Icons.dashboard,
            color: Colors.white,
            size: 22.0,
          ),
          Icon(
            Icons.favorite,
            color: Colors.white,
            size: 22.0,
          ),
          Icon(
            Icons.shopping_cart,
            color: Colors.white,
            size: 22.0,
          ),
          Icon(
            Icons.history,
            color: Colors.white,
            size: 22.0,
          ),
        ],
        color: Theme.of(context).primaryColor,
        buttonBackgroundColor: Theme.of(context).primaryColor,
        // FIXME Chagne background color to try different combination
        backgroundColor: _currentPage == 2 ? Colors.black12 : Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: _onBottomNavItemTap,
      ),
      body: PageStorage(
        bucket: bucket,
        child: pageList[_currentPage],
      ),
    );
  }
}
