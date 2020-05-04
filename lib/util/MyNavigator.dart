import 'package:flutter/material.dart';
import 'package:grocery/modal/Cart.dart';
import 'package:grocery/modal/Grocery.dart';
import 'package:grocery/screen/HomePage.dart';
import 'package:grocery/screen/LoginPage.dart';
import 'package:grocery/screen/ShopPage.dart';
import 'package:grocery/screen/SignupPage.dart';

class MyNavigator {
  static void goToSignUpPage(BuildContext context,List<Grocery> grocery){
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => SignupPage(grocery: grocery),
    ));
  }

  static void goToLoginPage(BuildContext context,List<Grocery> grocery){
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => LoginPage(grocery: grocery),
    ));
  }

  static void goToHomePage(BuildContext context,List<Grocery> grocery){
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => HomePage(grocery: grocery),
    ));
  }

  static void goToShopPage(BuildContext context, List<Cart> cart){
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ShopPage(cart: cart,),
    ));
  }
}