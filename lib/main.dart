import 'package:flutter/material.dart';
import 'package:grocery/screen/SplashPage.dart';
import 'package:grocery/util/DependencyInjection.dart';
import 'package:grocery/util/String.dart';

void main(){
  Injector.configure(Flavor.PROD);
  runApp(GroceryApp());
}

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
      home: SplashPage(),
    );
  }
}
