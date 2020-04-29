import 'package:flutter/material.dart';
import 'package:grocery/screen/HomePage.dart';
import 'package:grocery/screen/LoginPage.dart';
import 'package:grocery/screen/SignupPage.dart';
import 'package:grocery/util/String.dart';

void main() => runApp(GroceryApp());

class GroceryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      title: APP_TITLE,
      home: LoginPage(),
    );
  }
}
