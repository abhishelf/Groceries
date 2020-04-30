import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grocery/modal/Grocery.dart';
import 'package:grocery/modal/Profile.dart';
import 'package:grocery/presenter/GroceryPresenter.dart';
import 'package:grocery/presenter/ProfilePresenter.dart';
import 'package:grocery/util/MyNaigator.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> implements GroceryListViewContract, ProfileViewContract{

  GroceryPresenter _groceryPresenter;
  List<Grocery> _groceryList;

  ProfilePresenter _profilePresenter;
  Profile _profile;

  bool _isLoading = true;
  bool _isTimerFinished = false;

  String _loadingText = "Loading";

  _SplashPageState(){
    _profilePresenter = ProfilePresenter(this);
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
      if(_profile != null){
        MyNavigator.goToHomePage(context,_groceryList,_profile);
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
    _profilePresenter.loadProfile("abhishek.bitpatna@gmail.com");
  }

  @override
  void onLoadProfile(Profile profile) {
    setState(() {
      _isLoading = false;
      _profile = profile;
      if(_isTimerFinished){
        MyNavigator.goToHomePage(context, _groceryList, _profile);
      }
    });
  }
}
