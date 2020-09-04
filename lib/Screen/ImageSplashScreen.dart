import 'dart:async';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'WalkthroughApp.dart';

import '../Home/HomeActivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../UserAuth/Login.dart';
import '../Constant/ColorGlobal.dart';

class ImageSplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<ImageSplashScreen> {
  SharedPreferences sharedPreferences;
  String email;
  int flag;
  String dots="0";
  Timer _timer;
  Color getColorFromColorCode(String code){
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

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
  void changeDots(Timer timer) {
    int add = Random().nextInt(7);
    add = add %2 == 0 ? (add%4==0 ? 8 : 5) : (add%3==0 ? 10: (add%5==0 ? 5 : 14));
    String value = ((int.parse(dots)+add)%101).toString();
    if(int.parse(dots)!=100) {
      setState(() {
        dots = value;
      });
    }
    print("dots $dots");
//    if(dots.trim().length==3)
//      setState(() {
//        dots =  "   ";
//      });
//    else {
//      setState(() {
//        dots = dots.trim() + "." + " "*(2 - dots.trim().length);
//      });
//    }
  }

  @override
  void initState() {
    super.initState();
    _timer = new Timer.periodic(const Duration(milliseconds: 750),changeDots);
    startTime();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: width*0.7,
                      height: width*0.3,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: new BoxDecoration(
                        //color: ColorGlobal.colorPrimaryDark,
                          image: new DecorationImage(
                            image:  AssetImage('assets/images/recal_logo.jpg'),
                            colorFilter: ColorFilter.mode(Colors.white, BlendMode.darken),
                            fit: BoxFit.contain,
                          ),
                          borderRadius: BorderRadius.circular(width*0.1)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Text(
                        "RECAL UAE CHAPTER",
                        style: GoogleFonts.josefinSans(fontSize: 23.0, fontWeight: FontWeight.bold, color: ColorGlobal.textColor),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: SpinKitWave(
                            color: getColorFromColorCode("#6289ce"),
                            size: 50.0,
                            duration :Duration(milliseconds: 1000)
                        ),
                      ),
                    ),
                    Text(
                      "Loading $dots%",
                      style: GoogleFonts.josefinSans(fontSize: 20.0, fontWeight: FontWeight.w500, color: ColorGlobal.textColor),
                    ),
                  ],
                ),
              ]
          ),
        ],
      ),
    );
  }
}