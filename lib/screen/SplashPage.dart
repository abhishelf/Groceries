import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery/modal/Grocery.dart';
import 'package:grocery/presenter/GroceryPresenter.dart';
import 'package:grocery/util/BaseAuth.dart';
import 'package:grocery/util/MyNavigator.dart';
import 'package:grocery/util/String.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    implements GroceryListViewContract {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  GroceryPresenter _groceryPresenter;
  List<Grocery> _groceryList;

  bool _isLoading = true;
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
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        child: Image(
                          //FIXME change logo of app
                          image: AssetImage("images/apple.jpg"),
                          height: 50.0,
                          width: 50.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        APP_TITLE,
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
      content: Text("Please Check Your Connection"),
      action: SnackBarAction(
        label: "Retry",
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
      _isLoading = false;
      if (_isUserAuthenticated) {
        MyNavigator.goToHomePage(context, _groceryList);
      } else {
        MyNavigator.goToLoginPage(context, _groceryList);
      }
    }
  }
}
