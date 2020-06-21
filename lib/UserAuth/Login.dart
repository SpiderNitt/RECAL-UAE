import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import '../models/User.dart';
import 'package:page_transition/page_transition.dart';
import '../Home/HomeActivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant/Constant.dart';
import '../Profile/ProfileScreen.dart';
import '../Constant/ColorGlobal.dart';
import '../Constant/TextField.dart';
import 'package:http/http.dart' as http;

import 'SignUp.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() {
    return new LoginState();
  }
}

class LoginState extends State<Login> {
  var top = FractionalOffset.topCenter;
  var bottom = FractionalOffset.bottomCenter;
  double width = _textSize(
          "Don't have an account?",
          TextStyle(
            fontSize: 14,
            letterSpacing: 1,
            color: ColorGlobal.whiteColor.withOpacity(0.9),
            fontWeight: FontWeight.w400,
          )).width +
      50;
  TextEditingController email =
      new TextEditingController(text: "someone@gmail.com");
  TextEditingController password =
      new TextEditingController(text: "o84HWLLJ5pmd");

  FocusNode emailFocus = new FocusNode();
  FocusNode passwordFocus = new FocusNode();
  List<String> result = new List<String>();

  getDisposeController() {
    email.clear();
    password.clear();
    emailFocus.unfocus();
    passwordFocus.unfocus();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("LOGIN");
//    getDisposeController();
  }

  @override
  void dispose() {
    getDisposeController();
    // TODO: implement dispose
    super.dispose();
  }

  var list = [
    Colors.lightGreen,
    Colors.redAccent,
  ];
  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit the App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: FlatButton(
                  color: Colors.green,
                  child: Text("NO"),
                ),
              ),
              new GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pop(true);
                },
                child: FlatButton(
                  color: Colors.red,
                  child: Text("YES"),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  _loginDialog(String show, String again, int flag) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: Text('Login Check'),
            content: new Text(show),
            actions: <Widget>[
              new GestureDetector(
                onTap: () {
                  flag != 1
                      ? Navigator.of(context).pop(false)
                      : Navigator.pushReplacementNamed(context, HOME_PAGE);
                },
                child: FlatButton(
                  color: Colors.green,
                  child: Text(again),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  static _saveUserDetails(String email, String name, String userId, String cookie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Login email:  ${prefs.getString("email")}");
    print("Login name:  ${prefs.getString("name")}");
    prefs.setString("email", email);
    prefs.setString("name", name);
    prefs.setString("user_id", userId);
    prefs.setString("cookie", cookie);

    print("login save ${prefs.getString("name")}");
  }

  static Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  void updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
//      headers['cookie'] =
//      (index == -1) ? rawCookie : rawCookie.substring(0, index);
      print((index == -1) ? rawCookie : rawCookie.substring(0, index));
    }
  }

  static loginUser(String email, String password) async {
    var url = "https://delta.nitt.edu/recal-uae/api/auth/login/";
    var body = {'email': email, 'password': password};
    await http
        .post(
      url,
      body: body,
    )
        .then((_response) {
      User user = new User();
      ResponseBody responseBody = new ResponseBody();
      print('Response body: ${_response.body}');
      if (_response.statusCode == 200) {
//        updateCookie(_response);
        responseBody = ResponseBody.fromJson(json.decode(_response.body));
        if (responseBody.status_code == 200) {
          String rawCookie = _response.headers['set-cookie'];
          String cookie = rawCookie.substring(0, rawCookie.indexOf(';'));
          print(cookie);
          user = User.fromJson(json.decode(responseBody.data));
          var userId = user.user_id;
          _saveUserDetails(user.email, user.name, userId.toString(), cookie);
          return [user.name, 1];
        } else {
          print(responseBody.data);
          return [responseBody.data, 0];
        }
      } else {
        print('Server error');
        return ["Server Error", 0];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final accountSize = _textSize(
            "Don't have an account?",
            TextStyle(
              fontSize: 14,
              letterSpacing: 1,
              color: ColorGlobal.whiteColor.withOpacity(0.9),
              fontWeight: FontWeight.w400,
            )).width +
        50;
    print(width);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorGlobal.whiteColor,
          body: SingleChildScrollView(
            child: Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(),
                    height: size.height - 90,
                    decoration: BoxDecoration(
                      color: ColorGlobal.whiteColor,
//                  gradient: new LinearGradient(
//                    colors: [
//                      ColorGlobal.colorPrimaryDark.withOpacity(0.7),
//                      ColorGlobal.colorPrimary,
//                    ],
//                    begin: Alignment.topLeft,
//                    end: Alignment.bottomRight,
//                  ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 70),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ClipRRect(
                          child: Image.asset(
                            'assets/images/nitt_logo.png',
                            height: 120,
                            width: 120,
                          ),
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'RECAL UAE',
                          style: TextStyle(
                            color: ColorGlobal.textColor,
                            fontSize: 24.0,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: 22,
                      left: 22,
                      bottom: 22,
                      top: 270,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          child: TextFieldWidget(
                            hintText: 'Email',
                            obscureText: false,
                            prefixIconData: Icons.mail,
                            textEditingController: email,
                            focusNode: emailFocus,
                          ),
                        ),
                        SizedBox(
                          height: 22,
                        ),
                        Container(
                          child: TextFieldWidget(
                            hintText: 'Password',
                            obscureText: true,
                            prefixIconData: Icons.lock,
                            textEditingController: password,
                            focusNode: passwordFocus,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          color: Colors.transparent,
                          margin: EdgeInsets.only(
                            top: (15),
                            right: (8),
                            left: (8),
                            bottom: (10),
                          ),
                          //child: AuthButton(),
                          child: InkWell(
                            onTap: () async {
                              if (email.text != "" && password.text != "") {
                                var url =
                                    "https://delta.nitt.edu/recal-uae/api/auth/login/";
                                var body = {
                                  'email': email.text,
                                  'password': password.text
                                };
                                await http.post(
                                  url,
                                  body: body,
                                ).then((_response) {
                                  User user = new User();
                                  ResponseBody responseBody = new ResponseBody();
                                  print('Response body: ${_response.body}');

                                  if (_response.statusCode == 200) {
                                    String rawCookie = _response.headers['set-cookie'];
                                    String cookie = rawCookie.substring(0, rawCookie.indexOf(';'));
                                    print(cookie);
                                    responseBody = ResponseBody.fromJson(
                                        json.decode(_response.body));
                                    print(json.encode(responseBody.data));
                                    if (responseBody.status_code == 200) {
                                      user = User.fromJson(json.decode(
                                          json.encode(responseBody.data)));
                                      var userId = user.user_id;
                                      _saveUserDetails(user.email, user.name, userId.toString(), cookie);
                                      _loginDialog(
                                          "Login Success", "Proceed", 1);
                                    } else {
                                      print(responseBody.data);
                                      _loginDialog(
                                          responseBody.data, "Try again", 0);
                                    }
                                  } else {
                                    print("server error");
                                    _loginDialog(
                                        "Server Error", "Try again", 0);
                                  }
                                });
                              }
                              else {
                                _loginDialog(
                                    "Enter all fields", "Try again", 2);

                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                top: (30),
                                right: (8),
                                left: (8),
                              ),
                              height: (60.0),
                              decoration: BoxDecoration(
                                gradient: new LinearGradient(
                                  colors: [
                                    ColorGlobal.colorPrimary,
                                    ColorGlobal.colorPrimary.withOpacity(0.7),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorGlobal.colorPrimary,
                                    spreadRadius: 5,
                                    blurRadius: 0,
                                    // changes position of shadow
                                  ),
                                ],
                                border: Border.all(
                                  width: 2,
                                  color: ColorGlobal
                                      .colorPrimary, //                   <--- border width here
                                ),
                                color: ColorGlobal.colorPrimary,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    (22.0),
                                  ),
                                ),
                              ),
                              child: Container(
//                        margin: EdgeInsets.only(left: (10)),
                                alignment: Alignment.center,
                                child: Text(
                                  "SIGN IN",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    letterSpacing: 1,
                                    color: ColorGlobal.whiteColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Text(
                            "Forgot Password?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: ColorGlobal.textColor.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: ColorGlobal.whiteColor,
            height: 70,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        getDisposeController();
                        Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 300),
                                    child: SignUp()))
                            .then((value) {
                          Future.delayed(Duration(milliseconds: 200), () {
                            setState(() {
                              width = accountSize;
                            });
                          });
                        });
                        setState(() {
                          width = screenWidth - 20;
                        });
                      },
                      child: AnimatedContainer(
                        height: 65.0,
                        width: width,
                        duration: Duration(milliseconds: 500),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: ColorGlobal.whiteColor,
                                size: 30,
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
//                          margin: EdgeInsets.only(right: 8,top: 15),
                                    child: Text(
                                      "Don't have an account?",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        color: ColorGlobal.whiteColor
                                            .withOpacity(0.9),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
//                          margin: EdgeInsets.only(right: 8,top: 15),
                                    child: AutoSizeText(
                                      "Sign Up",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 16,
                                        letterSpacing: 1,
                                        color: ColorGlobal.whiteColor
                                            .withOpacity(0.9),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        curve: Curves.linear,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            topLeft: Radius.circular(40),
                          ),
                          color: ColorGlobal.colorPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

