import 'package:flutter/material.dart';
import 'package:aaharpurti/screen/SplashPage.dart';
import 'package:aaharpurti/util/DependencyInjection.dart';
import 'package:aaharpurti/util/String.dart';

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
