import 'dart:async';

import 'dart:convert';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/constants/UIUtility.dart';
import 'package:iosrecal/constants/Api.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iosrecal/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:http/http.dart' as http;

class ImageSplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<ImageSplashScreen> with WidgetsBindingObserver {
  SharedPreferences sharedPreferences;
  String email,uid,cookie;
  int flag;
  String dots="0";
  Timer _dotTimer, _navigationTimer;
  UIUtility uiUtills = new UIUtility();

  Color getColorFromColorCode(String code){
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  startTime() async {
    var _duration = new Duration(milliseconds:4100);
    return new Timer(_duration, navigationPage);
  }
  Future <Null> _getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email1 = prefs.getString("email")==null ? "+9,q": prefs.getString("email");
    String user_id = prefs.getString("user_id")==null ? "+9,q": prefs.getString("user_id");
    String cookie1 = prefs.getString("cookie") == null ? "+9,q" : prefs.getString("cookie");

    flag = prefs.getInt("first")==null ? 0 : prefs.getInt("first");
    print("splash: " + email1);
    print("first: $flag");

    if(email1!="+9,q" && user_id!="+9,q")
    setState(() {
      email=email1;
      uid = user_id;
      cookie = cookie1;
    });
  }

  Future <Null> _checkLogin () async {
    var url = Api.checkLogin;
    await http.get(url, headers: {'Cookie': cookie}).then((_response) async {
      print(_response.statusCode);
      print(_response.body);
      if (_response.statusCode == 200) {
        ResponseBody responseBody =
        ResponseBody.fromJson(json.decode(_response.body));
        print(json.encode(responseBody.data));
        if (responseBody.status_code == 200) {
          User user = User.fromCheckLogin(responseBody.data);
          if(user.loggedIn==true)
            Navigator.pushReplacementNamed(context, HOME_SCREEN);
          else
            Navigator.pushReplacementNamed(context, LOGIN_SCREEN);

        } else {
          Navigator.pushReplacementNamed(context, LOGIN_SCREEN);
          print("${responseBody.data}");
        }
      } else {
        Navigator.pushReplacementNamed(context, LOGIN_SCREEN);
        print("Server error");
      }
    }).catchError((error) {
      Navigator.pushReplacementNamed(context, LOGIN_SCREEN);
      print(error);
    });
  }

  void navigationPage() async {
    await _getUserDetails();
    print("nav page: $email");
//    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WalkThroughApp()));
      if (flag ==0) {
        Navigator.pushReplacementNamed(context, INTRO_PAGE);
      }
      else if (email != null && uid != null && cookie != null) {
        //await _checkLogin();
        Navigator.pushReplacementNamed(context, HOME_SCREEN);
      }
      else {
        //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WalkThroughApp()));
        Navigator.pushReplacementNamed(context, LOGIN_SCREEN);
      }
    }
  void changeDots(Timer timer) {
    int add = Random().nextInt(7);
    add = add %2 == 0 ? (add%4==0 ? 15 : 13) : (add%3==0 ? 17: (add%5==0 ? 11 : 21));
    String value = ((int.parse(dots)+add) > 100 ? 100 : (int.parse(dots)+add)).toString();
    if(int.parse(dots)<=100) {
      if(!mounted) return;
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
    print("started");
    WidgetsBinding.instance.addObserver(this);
    uiUtills = new UIUtility();
    _dotTimer = new Timer.periodic(const Duration(milliseconds: 750),changeDots);
    _navigationTimer = new Timer(Duration(milliseconds: 3100),navigationPage);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    _dotTimer.cancel();
    _navigationTimer.cancel();
    print("dispose");
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      print("resumed");
      setState(() {
        _dotTimer = new Timer.periodic(const Duration(milliseconds: 750),changeDots);
        _navigationTimer = new Timer(Duration(milliseconds: 4100),navigationPage);
        dots="0";
      });
    }
    else if(state == AppLifecycleState.inactive){
      print("inactive");
      _dotTimer.cancel();
      _navigationTimer.cancel();
    }
    else if(state == AppLifecycleState.paused){
      print("paused");
      _dotTimer.cancel();
      _navigationTimer.cancel();
    }
    else if(state == AppLifecycleState.detached){
      print("detached");
      _dotTimer.cancel();
      _navigationTimer.cancel();
    }
  }
  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;
    uiUtills.updateScreenDimesion(width: width, height: height);
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
                    padding: EdgeInsets.all(getWidth(30, 1)),
                    child: Text(
                      "RECAL UAE CHAPTER",
                      style: GoogleFonts.josefinSans(fontSize: getWidth(23,1), fontWeight: FontWeight.bold, color: ColorGlobal.textColor),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: getHeight(10, 1)),
                      child: SpinKitWave(
                      color: getColorFromColorCode("#6289ce"),
                      size: getWidth(50, 1),
                      duration :Duration(milliseconds: 1000)
                      ),
                    ),
                  ),
                  Text(
                    "Loading $dots%",
                    style: GoogleFonts.josefinSans(fontSize: getWidth(20, 1), fontWeight: FontWeight.w500, color: ColorGlobal.textColor),
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