import 'dart:async';
import 'WalkthroughApp.dart';

import '../Home/HomeActivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../UserAuth/Login.dart';

class ImageSplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<ImageSplashScreen> {
  SharedPreferences sharedPreferences;
  String email;
  int flag;

  startTime() async {
  var _duration = new Duration(seconds:1);
    return new Timer(_duration, navigationPage);
  }
  Future <Null> _getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("email")==null ? "+9,q": prefs.getString("email");
    flag = prefs.getInt("first")==null ? 0 : prefs.getInt("first");
    prefs.setInt("first", 10);
    print("splash: " + id);
    print("first: $flag");
    if(id!="+9,q")
    setState(() {
      email=id;
    });
  }

  void navigationPage() async {
    await _getUserDetails();
    print("nav page: $email");

    if(flag==0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WalkThroughApp()));
    }
    else if(email!=null) {
      Navigator.pushReplacementNamed(context, HOME_PAGE);
    }
    else {
   //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WalkThroughApp()));
      Navigator.pushReplacementNamed(context, LOGIN_SCREEN);
    }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset('assets/images/nitt_logo.png',alignment: Alignment.topCenter, scale: 1.3),
              Padding(
                padding: const EdgeInsets.only(
                    left: 0.0, right: 0.0, top: 0.0, bottom: 120.0),
                child:
                  new Text(
                    "RECAL",
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
                child:
                  Image.asset('assets/images/loading.gif', alignment: Alignment.bottomCenter, scale : 4.0),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 0.0, right: 0.0, top: 50.0, bottom: 0.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Image.asset('assets/images/spiderlogo.png',
                        height: 20.0, width: 20.0),
                    Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: new Text(
                          "Weaved Together ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: Colors.white
                          ),
                        ))
                  ],
                ),
              ),
            ]
          ),
        ],
      ),
    );
  }
}