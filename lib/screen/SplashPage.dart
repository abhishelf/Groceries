import 'dart:async';

import 'package:flutter/material.dart';
import 'package:aaharpurti/modal/Grocery.dart';
import 'package:aaharpurti/presenter/GroceryPresenter.dart';
import 'package:aaharpurti/util/BaseAuth.dart';
import 'package:aaharpurti/util/MyNavigator.dart';
import 'package:aaharpurti/util/String.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    implements GroceryListViewContract {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  GroceryPresenter _groceryPresenter;
  List<Grocery> _groceryList;

  bool _isTimerFinished = false;
  bool _isUserAuthenticated;

  String _loadingText = "Please Wait";

  _SplashPageState() {
    _groceryPresenter = GroceryPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _checkUserAuth();

    Timer(Duration(seconds: 5), () {
      _isTimerFinished = true;
      if (_groceryList != null) {
        if (_isUserAuthenticated) {
          MyNavigator.goToHomePage(context, _groceryList);
        } else {
          MyNavigator.goToLoginPage(context, _groceryList);
        }
      }
    });
  }

  _checkUserAuth() {
    Auth().getCurrentUser().then((user) {
      if (user != null) {
        user?.uid == null
            ? _isUserAuthenticated = false
            : _isUserAuthenticated = true;
      } else {
        _isUserAuthenticated = false;
      }
      _groceryPresenter.loadGroceryList();
    }).catchError((_) {
      _isUserAuthenticated = false;
      _groceryPresenter.loadGroceryList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.lightGreen,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage("images/logo.png"),
                        height: 150.0,
                        width: 150.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        "",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 64.0),
                          child: CircularProgressIndicator()),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      Text(
                        _loadingText,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.lightGreen),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _showErrorSnackBar() {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(ERROR_NETWORK),
      action: SnackBarAction(
        label: BUTTON_RETRY,
        onPressed: () {
          _groceryPresenter.loadGroceryList();
          _scaffoldKey.currentState.removeCurrentSnackBar();
        },
      ),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 60),
    ));
  }

  @override
  void onLoadException(String error) {
    _showErrorSnackBar();
  }

  @override
  void onLoadGrocery(List<Grocery> groceryList) {
    _groceryList = groceryList;
    if (_isTimerFinished) {
      if (_isUserAuthenticated) {
        MyNavigator.goToHomePage(context, _groceryList);
      } else {
        MyNavigator.goToLoginPage(context, _groceryList);
      }
    }
  }
}
