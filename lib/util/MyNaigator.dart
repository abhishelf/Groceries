import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/modal/Grocery.dart';
import 'package:grocery/modal/Profile.dart';
import 'package:grocery/screen/HomePage.dart';
import 'package:grocery/screen/LoginPage.dart';
import 'package:grocery/screen/SignupPage.dart';

class MyNavigator {
  static void goToSignUpPage(BuildContext context){
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => SignupPage(),
    ));
  }

  static void goToLoginPage(BuildContext context,List<Grocery> grocery, Profile profile){
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => LoginPage(),
    ));
  }

  static void goToHomePage(BuildContext context,List<Grocery> grocery, Profile profile){
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => HomePage(grocery: grocery,profile: profile),
    ));
  }
}