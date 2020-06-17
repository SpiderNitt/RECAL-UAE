
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../Home/HomeActivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant/Constant.dart';
import '../Profile/ProfileScreen.dart';
import '../Constant/ColorGlobal.dart';
import '../Constant/TextField.dart';

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
  double width = 220.0;
  double widthIcon = 200.0;
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  FocusNode emailFocus = new FocusNode();
  FocusNode passwordFocus = new FocusNode();

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
    getDisposeController();
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

  _saveUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Login:  ${prefs.getString("userID")}");
    prefs.setString("userID", email.text);
    print("login save ${prefs.getString("userID")}");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

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
                    height: size.height-90,
                    decoration: BoxDecoration(
                      color:  ColorGlobal.whiteColor,
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
                          child:   InkWell(
                            onTap: () {
                              if(email.text!="") {
                                _saveUserDetails();
                                Navigator.pushReplacementNamed(context, HOME_PAGE);
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
                          Future.delayed(Duration(milliseconds: 300), () {
                            setState(() {
                              width = 220;
                              widthIcon = 200;
                            });
                          });
                        });
                        setState(() {
                          width = 360.0;
                          widthIcon = 0;
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
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
//                          margin: EdgeInsets.only(right: 8,top: 15),
                                    child: Text(
                                      "Don't have an account?",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        color:
                                            ColorGlobal.whiteColor.withOpacity(0.9),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
//                          margin: EdgeInsets.only(right: 8,top: 15),
                                    child: Text(
                                      "Sign Up",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 16,
                                        letterSpacing: 1,
                                        color: ColorGlobal.whiteColor.withOpacity(0.9),
                                        fontWeight: FontWeight.w600,
                                      ),
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

