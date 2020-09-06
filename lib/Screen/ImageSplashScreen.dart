import 'dart:async';

import 'dart:convert';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/models/User.dart';

import 'WalkthroughApp.dart';

import '../Home/HomeActivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../UserAuth/Login.dart';
import '../Constant/ColorGlobal.dart';
import 'package:http/http.dart' as http;

class ImageSplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<ImageSplashScreen> {
  SharedPreferences sharedPreferences;
  String email,uid,cookie;
  int flag;
  String dots="0";
  Timer _timer;
  Color getColorFromColorCode(String code){
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  startTime() async {

  var _duration = new Duration(seconds:4);
    return new Timer(_duration, navigationPage);
  }
  Future <Null> _getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email1 = prefs.getString("email")==null ? "+9,q": prefs.getString("email");
    String user_id = prefs.getString("user_id")==null ? "+9,q": prefs.getString("user_id");
    String cookie1 = prefs.getString("cookie") == null ? "+9,q" : prefs.getString("cookie");

    flag = prefs.getInt("first")==null ? 0 : prefs.getInt("first");
    prefs.setInt("first", 10);
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
    var url = "https://delta.nitt.edu/recal-uae/api/auth/check_login/";
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
            Navigator.pushReplacementNamed(context, HOME_PAGE);
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

    if(flag==0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WalkThroughApp()));
    }
    else if(email!=null && uid!=null && cookie!=null) {
     await _checkLogin();
    }
    else {
      //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WalkThroughApp()));
      Navigator.pushReplacementNamed(context, LOGIN_SCREEN);
    }
  }
  void changeDots(Timer timer) {
    int add = Random().nextInt(7);
    add = add %2 == 0 ? (add%4==0 ? 10 : 7) : (add%3==0 ? 11: (add%5==0 ? 6 : 16));
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