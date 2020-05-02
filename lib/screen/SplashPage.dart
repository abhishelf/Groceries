import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grocery/modal/Grocery.dart';
import 'package:grocery/presenter/GroceryPresenter.dart';
import 'package:grocery/util/MyNaigator.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> implements GroceryListViewContract{

  GroceryPresenter _groceryPresenter;
  List<Grocery> _groceryList;

  bool _isLoading = true;
  bool _isTimerFinished = false;

  String _loadingText = "Loading";

  _SplashPageState(){
    _groceryPresenter = GroceryPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _isTimerFinished = false;
    _isLoading = true;

    _groceryPresenter.loadGroceryList();

    Timer(Duration(seconds: 5), () {
      _isTimerFinished = true;
      if(_groceryList != null){
        MyNavigator.goToHomePage(context,_groceryList);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CircularProgressIndicator(),
    );
  }

  @override
  void onLoadException(String error) {
    print("ERROR --- "+error);
  }

  @override
  void onLoadGrocery(List<Grocery> groceryList) {
    _groceryList = groceryList;
    if(_isTimerFinished){
      _isLoading = false;
      MyNavigator.goToHomePage(context, _groceryList);
    }
  }
}
