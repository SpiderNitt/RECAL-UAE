import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/models/LoginData.dart';
import 'package:iosrecal/screens/Home/Arguments.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:iosrecal/models/User.dart';
import 'package:iosrecal/Constant/Constant.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:iosrecal/Constant/TextField.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() {
    return new LoginState();
  }
}

class LoginState extends State<Login> {
  var top = FractionalOffset.topCenter;
  var bottom = FractionalOffset.bottomCenter;

  TimeoutArguments args;
  TextEditingController email =
  new TextEditingController(text: "someone2@gmail.com");
  TextEditingController password =
  new TextEditingController(text: "1j7P1T3ync2I");
  TextEditingController newPassword = new TextEditingController(text: "");
  TextEditingController confirmPassword = new TextEditingController(text: "");

  FocusNode emailFocus = new FocusNode();
  FocusNode passwordFocus = new FocusNode();
  FocusNode newPasswordFocus = new FocusNode();
  FocusNode confirmPasswordFocus = new FocusNode();

  bool changePassword = false;
  String primaryButtonText = "SIGN IN";
  String secondaryButtonText = "Change Password";
  String pageTitle = "SIGN IN";

  ProgressDialog progressDialog;

  List<String> result = new List<String>();

  Color getColorFromColorCode(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  _initController() {
    email = new TextEditingController(text: "someone2@gmail.com");
    password = new TextEditingController(text: "1j7P1T3ync2I");
    newPassword = new TextEditingController(text: "");
    confirmPassword = new TextEditingController(text: "");

    emailFocus = new FocusNode();
    passwordFocus = new FocusNode();
    newPasswordFocus = new FocusNode();
    confirmPasswordFocus = new FocusNode();
  }

  _disposeController() {
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

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit the App'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            color: Colors.green,
            child: Text("NO"),

          new GestureDetector(
            child: FlatButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(true),
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
    if (progressDialog == null) {
      progressDialog = new ProgressDialog(
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

      progressDialog.style(
        message: changePassword == true ? "Sending mail" : "Logging In",
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
      progressDialog.show();
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
        progressDialog.update(
            message: show.replaceAll("!", ""), progressWidget: prog);
      });
      Future.delayed(Duration(milliseconds: 2000)).then((value) {
        progressDialog.update(progressWidget: null);
        progressDialog.hide();
        setState(() {
          progressDialog = null;
        });
      });
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

  Future<dynamic> passwordReset(String email) async {
    var url = "https://delta.nitt.edu/recal-uae/api/auth/pass_reset/";
    var body = {
      'email': email,
    };
    await http.post(
      url,
      body: body,
    );
  }

  @override
  void initState() {
    super.initState();
    _deleteUserDetails();
    _initController();
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    args = ModalRoute.of(context).settings.arguments;
    if(args!=null && args==true){
      print("auth is true");
    }
    return Provider<LoginData>(
      create: (context) => LoginData(),
      child: WillPopScope(
          onWillPop: _onBackPressed,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: ColorGlobal.whiteColor,
              body: Center(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(0.05 * width),
                          child: Container(
                            width: width,
                            height: width * 0.35,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: new BoxDecoration(
                                color: ColorGlobal.colorPrimaryDark,
                                image: new DecorationImage(
                                  image: new AssetImage(
                                      'assets/images/recal_logo.jpg'),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius:
                                BorderRadius.circular(width * 0.1)),
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
                                side: BorderSide(
                                    color:
                                    ColorGlobal.whiteColor.withOpacity(0.8),
                                    width: 0.5),
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
                                    passwordVisible: true,
                                    textEditingController: email,
                                    focusNode: emailFocus,
                                  ),
                                ),
                                changePassword == false
                                    ? Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: TextFieldWidget(
                                    hintText: "Password",
                                    obscureText: true,
                                    prefixIconData: Icons.lock,
                                    passwordVisible: false,
                                    textEditingController: password,
                                    focusNode: passwordFocus,
                                  ),
                                )
                                    : Container(),
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
                                      child: Consumer<LoginData>(
                                        builder: (context, loginData, child) {
                                          return InkWell(
                                            onTap: () async {
                                              if (changePassword == false) {
                                                if (email.text != "" &&
                                                    password.text != "") {
                                                  await loginData.loginUser(
                                                      email.text,
                                                      password.text);
                                                  if (loginData.user == null) {
                                                    await _loginDialog(
                                                        "Invalid Credentials",
                                                        "Try again",
                                                        2);
                                                  } else {
                                                    User user = loginData.user;
                                                    await user
                                                        .saveUserDetails();
                                                    await _loginDialog(
                                                        "Login Successful",
                                                        "Proceed",
                                                        1);
                                                    if (args != null &&
                                                        args.auth) {

                                                      Future.delayed(
                                                          Duration(
                                                              milliseconds: 2000),
                                                              () {
                                                            Navigator
                                                                .pop(context);
                                                          });
                                                    }
                                                    else {
                                                      Future.delayed(
                                                          Duration(
                                                              milliseconds: 2000),
                                                              () {
                                                            Navigator
                                                                .pushReplacementNamed(
                                                                context,
                                                                HOME_PAGE);
                                                          });
                                                    }
                                                  }
                                                } else {
                                                  await _loginDialog(
                                                      "Enter all fields",
                                                      "Try again",
                                                      2);
                                                }
                                              } else {
                                                if (email.text != "") {
                                                  _loginDialog(
                                                      "Email has been sent",
                                                      "",
                                                      1);
                                                } else {
                                                  _loginDialog(
                                                      "Enter all fields",
                                                      "Try again",
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
                                                  duration:
                                                  Duration(seconds: 1),
                                                  child: primaryWidget(),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        changePassword = !changePassword;
                                        primaryButtonText =
                                        primaryButtonText == "SIGN IN"
                                            ? "SUBMIT"
                                            : "SIGN IN";
                                        secondaryButtonText =
                                        secondaryButtonText ==
                                            "Change Password"
                                            ? "Return to Sign in"
                                            : "Change Password";
                                        pageTitle = pageTitle == "SIGN IN"
                                            ? "RESET PASSWORD"
                                            : "SIGN IN";
                                        emailFocus.unfocus();
                                        passwordFocus.unfocus();
                                      });
                                    },
                                    child: AnimatedSwitcher(
                                      duration: Duration(seconds: 1),
                                      child: secondaryWidget(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: AutoSizeText(
                                    "Note: Don't have the credentials? Write an email to recaluaechapter@gmail.com",
                                    maxLines: 4,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: ColorGlobal.textColor
                                          .withOpacity(0.9),
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
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
          )),
    );
  }
}