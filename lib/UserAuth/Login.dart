import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:progress_dialog/progress_dialog.dart';
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
      new TextEditingController(text: "1j7P1T3ync2I");
  TextEditingController newPassword =
  new TextEditingController(text: "");
  TextEditingController confirmPassword =
  new TextEditingController(text: "");



  FocusNode emailFocus = new FocusNode();
  FocusNode passwordFocus = new FocusNode();
  FocusNode newPasswordFocus = new FocusNode();
  FocusNode confirmPasswordFocus = new FocusNode();

  bool changePassword = false;
  String primaryButtonText = "SIGN IN";
  String secondaryButtonText = "Change Password";
  String pageTitle = "SIGN IN";

  List<String> result = new List<String>();

  Color getColorFromColorCode(String code){
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  getDisposeController() {
    email.clear();
    password.clear();
    newPassword.clear();
    confirmPassword.clear();
    emailFocus.unfocus();
    passwordFocus.unfocus();
    newPasswordFocus.unfocus();
    confirmPasswordFocus.unfocus();
  }

  _deleteUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", null);
    prefs.setString("name", null);
    prefs.setString("user_id", null);
    prefs.setString("cookie", null);
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

  _loginDialog1(ProgressDialog pr, String show, String again, int flag) {
    pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      textDirection: TextDirection.rtl,
      showLogs: true,
      isDismissible: false,
//      customBody: LinearProgressIndicator(
//        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
//        backgroundColor: Colors.white,
//      ),
    );

    pr.style(
      message:  changePassword == true ? "..Sending mail" : "..Logging In",
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      progressWidget: Image.asset(
        "assets/images/ring.gif",
        height: 50,
        width: 50,
      ),
      insetAnimCurve: Curves.easeInOut,
      progressWidgetAlignment: Alignment.center,
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600),
    );
    pr.show();
    Future.delayed(Duration(milliseconds: 1000)).then((value) {
      Widget prog = flag == 1
          ? Icon(
              Icons.check_circle,
              size: 50,
              color: Colors.green,
            )
          : Icon(
              Icons.close,
              size: 50,
              color: Colors.red,
            );
      pr.update(message: show.replaceAll("!", ""), progressWidget: prog);
    });
    Future.delayed(Duration(milliseconds: 2000)).then((value) {
      pr.update(progressWidget: null);
      pr.hide();
    });
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

  static _saveUserDetails(
      String email, String name, String userId, String cookie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Login email before:  ${prefs.getString("email")}");
    print("Login name before:  ${prefs.getString("name")}");
    prefs.setString("email", email);
    prefs.setString("name", name);
    prefs.setString("user_id", userId);
    prefs.setString("cookie", cookie);
    print("cookie: " + cookie);
    print("login after name ${prefs.getString("name")}");
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
  Widget primaryWidget() {
    return Text(
      primaryButtonText,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 15,
        color: ColorGlobal.whiteColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }
  Widget secondaryWidget() {
    return Text(
      secondaryButtonText,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 15,
        color: ColorGlobal.textColor.withOpacity(0.9),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Future <dynamic> passwordReset(String email) async {
    var url =
        "https://delta.nitt.edu/recal-uae/api/auth/pass_reset/";
    var body = {
      'email': email,
    };
    await http
        .post(
      url,
      body: body,
    );

  }

  Future<dynamic> loginUser(String email, String password) async {
    var url =
        "https://delta.nitt.edu/recal-uae/api/auth/login/";
    print("password: " + password);

    var body = {
      'email': email,
      'password': password
    };
    await http
        .post(
      url,
      body: body,
    )
        .then((_response) async {
      ProgressDialog progressDialog;
      User user = new User();
      ResponseBody responseBody =
      new ResponseBody();
      print('Response body: ${_response.body}');

      if (_response.statusCode == 200) {
        responseBody = ResponseBody.fromJson(
            json.decode(_response.body));
        print(json.encode(responseBody.data));
        if (responseBody.status_code == 200) {
          String rawCookie =
          _response.headers['set-cookie'];
          String cookie = rawCookie.substring(
              0, rawCookie.indexOf(';'));
          print(cookie);
          user = User.fromLogin(json.decode(
              json.encode(responseBody.data)));
          var userId = user.user_id;
           await _saveUserDetails(user.email, user.name,
                userId.toString(), cookie);
            _loginDialog1(progressDialog,
                "Login Successful", "Proceed", 1);
            if(changePassword==false) {
              Future.delayed(
                  Duration(milliseconds: 2000), () {
                Navigator.pushReplacementNamed(
                    context, HOME_PAGE);
              });
            }
        } else {
          print(responseBody.data);
          _loginDialog1(progressDialog,
              "${responseBody.data}", "Try again", 0);

        }
      } else {
        print("server error");
        _loginDialog1(progressDialog,
            "Server Error", "Try again", 0);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    email = TextEditingController(text: "someone@gmail.com");
    password = TextEditingController(text: "1j7P1T3ync2I");
    super.initState();
    print("LOGIN");
    _deleteUserDetails();

// =   getDisposeController();
  }

  @override
  void dispose() {
    getDisposeController();
    // TODO: implement dispose
    super.dispose();
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
          body:
          Center(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 0.1*width),
                      child: Container(
                        width: width,
                        height: width * 0.4,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: new BoxDecoration(
                            color: ColorGlobal.colorPrimaryDark,
                            image: new DecorationImage(
                              image: new AssetImage(
                                  'assets/images/recal_logo.jpg'),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(width * 0.1)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'RECAL UAE CHAPTER',
                            style: GoogleFonts.lato(
                              color: ColorGlobal.textColor,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: ColorGlobal.whiteColor.withOpacity(0.8), width: 0.5),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                pageTitle,
                                style: GoogleFonts.josefinSans(
                                  color: ColorGlobal.textColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextFieldWidget(
                                hintText: 'Email',
                                obscureText: false,
                                prefixIconData: Icons.mail,
                                textEditingController: email,
                                focusNode: emailFocus,
                              ),
                            ),
                           changePassword==false ? Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextFieldWidget(
                                hintText: "Password",
                                obscureText: true,
                                prefixIconData: Icons.lock,
                                textEditingController: password,
                                focusNode: passwordFocus,
                              ),
                            ) : Container(),
//                          changePassword == true ?  Padding(
//                            padding: const EdgeInsets.all(10),
//                            child: TextFieldWidget(
//                              hintText: 'New Password',
//                              obscureText: true,
//                              prefixIconData: Icons.lock,
//                              textEditingController: newPassword,
//                              focusNode: newPasswordFocus,
//                            ),
//                          ) : Container(),
//                          changePassword == true ?  Padding(
//                            padding: const EdgeInsets.all(10),
//                            child: TextFieldWidget(
//                              hintText: 'Confirm Password',
//                              obscureText: true,
//                              prefixIconData: Icons.lock,
//                              textEditingController: confirmPassword,
//                              focusNode: confirmPasswordFocus,
//                            ),
//                          ) : Container(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      if(changePassword==false) {
                                        if (email.text != "" &&
                                            password.text != "") {
                                          await loginUser(
                                              email.text, password.text);
                                        } else {
                                          _loginDialog(
                                              "Enter all fields", "Try again", 2);
                                        }
                                      }
                                      else {
                                        if(email.text!="") {
                                          ProgressDialog pr;
                                            _loginDialog1(pr,"Email has been sent", "", 1);
                                          }
                                        else {
                                          _loginDialog(
                                              "Enter all fields", "Try again",
                                              2);
                                        }
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: ColorGlobal.colorPrimary,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            (10),
                                          ),
                                        ),
                                      ),
                                      child: Container(
//                        margin: EdgeInsets.only(left: (10)),
                                        alignment: Alignment.center,
                                        child: AnimatedSwitcher(
                                          duration: Duration(seconds: 1),
                                          child: primaryWidget(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20,bottom: 10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    changePassword = !changePassword;
                                    primaryButtonText = primaryButtonText == "SIGN IN" ? "SUBMIT" : "SIGN IN";
                                    secondaryButtonText = secondaryButtonText == "Change Password" ? "Return to Sign in" : "Change Password";
                                    pageTitle = pageTitle == "SIGN IN" ? "RESET PASSWORD" : "SIGN IN";
                                    emailFocus.unfocus();
                                    passwordFocus.unfocus();
                                  });
                                },
                                child: AnimatedSwitcher(
                                  duration: Duration(seconds: 1),
                                  child: secondaryWidget() ,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                           changePassword==false? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: AutoSizeText(
                                "Note: Don't have the credentials? Write an email to recaluaechapter@gmail.com",
                                maxLines: 4,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: ColorGlobal.textColor.withOpacity(0.9),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ) : Container(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ),
    )
    );
  }
}
