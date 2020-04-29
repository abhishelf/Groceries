import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/screen/HomePage.dart';
import 'package:grocery/screen/SignupPage.dart';

class MyNavigator {
  static void goToSignUpPage(BuildContext context){
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => SignupPage(),
    ));
  }

  static void goToHomePage(BuildContext context){
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => HomePage(),
    ));
  }
}