import 'dart:async';

import 'package:AeologicSplashDemo/Constant/Constant.dart';
import 'package:AeologicSplashDemo/Screen/HomePage.dart';
import 'package:AeologicSplashDemo/Screen/ImageSplashScreen.dart';
import 'package:flutter/material.dart';

Future main() async {
  runApp(new MaterialApp(
    title: 'FluterSplashDemo',
    debugShowCheckedModeBanner: false,
    theme: new ThemeData(
      primarySwatch: Colors.red,
    ),
    home: new ImageSplashScreen(),
    routes: <String, WidgetBuilder>{
      HOME_SCREEN: (BuildContext context) => new HomeScreen(),
      IMAGE_SPLASH: (BuildContext context) => new ImageSplashScreen()
    },
  ));
}

