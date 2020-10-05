import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:iosrecal/routes.dart';
import 'package:iosrecal/widgets/TextField.dart';
import 'package:iosrecal/constants/UIUtility.dart';
import 'package:iosrecal/constants/Api.dart';
import 'package:iosrecal/bloc/KeyboardBloc.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;



class PasswordReset extends StatefulWidget {
  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  TextEditingController token = new TextEditingController(text: "");
  TextEditingController newPassword = new TextEditingController(text: "");
  TextEditingController confirmPassword = new TextEditingController(text: "");
  FocusNode tokenFocus = new FocusNode();
  FocusNode newPasswordFocus = new FocusNode();
  FocusNode confirmPasswordFocus = new FocusNode();
  UIUtility uiUtills = new UIUtility();
  KeyboardBloc _bloc = new KeyboardBloc();
  ProgressDialog progressDialog;

  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }
  _disposeController() {
    token.clear();
    newPassword.clear();
    confirmPassword.clear();
    tokenFocus.unfocus();
    newPasswordFocus.unfocus();
    confirmPasswordFocus.unfocus();
    _bloc.dispose();
  }
  _passwordDialog(String show, String again, int flag) {
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
        message: "Changing password",
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
            color: Colors.black,
            fontSize: getWidth(18, 1),
            fontWeight: FontWeight.w600),
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
  Future<dynamic> passwordUpdate(String token, String password) async {
    bool internetConnection = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        internetConnection = true;
      }
    } on SocketException catch (_) {
      print('not connected');
    }
    if(internetConnection==true) {
      var url = Api.passwordUpdate;
      var body = {
        'token': token,
        'new_password': password,
      };
      await http
          .post(
        url,
        body: body,
      )
          .then((_response) async {
        ResponseBody responseBody = new ResponseBody();
        print('Response body: ${_response.body}');

        if (_response.statusCode == 200) {
          responseBody = ResponseBody.fromJson(json.decode(_response.body));
          print(json.encode(responseBody.data));
          if (responseBody.status_code == 200) {
            print(responseBody.data);
            await _passwordDialog(
                "Update Successful",
                "Proceed",
                1);
            Future.delayed(
                Duration(
                    milliseconds: 2000),
                    () {
                  Navigator.pop(context);
                });
          } else {
            print(responseBody.data);
            await _passwordDialog(
                "Invalid Token",
                "Try again",
                2);
          }
        } else {
          await _passwordDialog(
              "Server Error",
              "Try again",
              2);
          print("server error");
        }
      }).catchError((onError) async {
        await _passwordDialog(
            "Server Error",
            "Try again",
            2);
        print("server error");
      });
    }
    else {
      _passwordDialog("No Internet Connection", "Try Again", 2);
    }
  }
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('Are you sure?'),
        content : Text('You will return to the login screen.'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          FlatButton(
            onPressed: () =>
                Navigator.of(context).pop(true),
            child: Text("YES"),
          )
        ],
      ),
    ) ??
        false;
  }
 Future<bool> _onBackDialog() {
    return  showDialog(
        context: context,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        "Cannot go back at this stage",
                        style: GoogleFonts.lato(
                          color: ColorGlobal.textColor,
                          fontSize: getWidth(20, 1),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // To close the dialog
                        },
                        child: Text("OK",
                            style: GoogleFonts.lato(
                              color: ColorGlobal.blueColor,
                              fontSize: getWidth(18, 1),
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                    ),
                  ],
                ),
              )),
        )) ?? false;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uiUtills = new UIUtility();
    _bloc.start();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    uiUtills.updateScreenDimesion(width: width, height: height);

    return Scaffold(
      backgroundColor: ColorGlobal.whiteColor,
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(0.05 * width),
                  child: Container(
                    width: width,
                    height: width * 0.35,
                    padding:
                    EdgeInsets.symmetric(horizontal: getWidth(20, 1)),
                    decoration: new BoxDecoration(
                        color: ColorGlobal.colorPrimaryDark,
                        image: new DecorationImage(
                          image:
                          new AssetImage('assets/images/recal_logo.jpg'),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(width * 0.1)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: getHeight(10, 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'RECAL UAE CHAPTER',
                        style: GoogleFonts.lato(
                          color: ColorGlobal.textColor,
                          fontSize: getWidth(22, 1),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: getHeight(20, 1),
                    left: getWidth(20, 1),
                    right: getWidth(20, 1),
                    bottom: getHeight(20, 1),
                  ),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: ColorGlobal.whiteColor.withOpacity(0.8),
                            width: 0.5),
                        borderRadius: BorderRadius.circular(getWidth(20, 1))),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: getHeight(20, 1)),
                            child: Text(
                              "CHANGE PASSWORD",
                              style: GoogleFonts.josefinSans(
                                color: ColorGlobal.textColor,
                                fontSize: getWidth(18, 1),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(getWidth(10, 1)),
                            child: TextFieldWidget(
                              hintText: 'Token',
                              obscureText: false,
                              prefixIconData: Icons.security,
                              passwordVisible: true,
                              textEditingController: token,
                              focusNode: tokenFocus,
                            ),
                          ),
                        ),
                       Center(
                          child: Padding(
                            padding: EdgeInsets.all(getWidth(10, 1)),
                            child: TextFieldWidget(
                              hintText: "New Password",
                              obscureText: true,
                              prefixIconData: Icons.lock,
                              passwordVisible: false,
                              textEditingController: newPassword,
                              focusNode: newPasswordFocus,
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(getWidth(10, 1)),
                            child: TextFieldWidget(
                              hintText: "Confirm Password",
                              obscureText: true,
                              prefixIconData: Icons.lock,
                              passwordVisible: false,
                              textEditingController: confirmPassword,
                              focusNode: confirmPasswordFocus,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(getHeight(20, 1)),
                              child: Container(
                                color: Colors.transparent,
                                child: InkWell(
                                      onTap: () async {
                                        if(newPassword.text.trim()=="" || confirmPassword.text.trim()=="" || token.text.trim()=="") {
                                          await _passwordDialog(
                                              "Enter all fields",
                                              "Try again",
                                              2);
                                        }
                                        else if(newPassword.text.trim()!=confirmPassword.text.trim()) {
                                          await _passwordDialog(
                                              "Passwords don't match",
                                              "Try again",
                                              2);
                                        }
                                        else {
                                          passwordUpdate(token.text.trim(), newPassword.text.trim());
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding:
                                        EdgeInsets.all(getWidth(10, 1)),
                                        decoration: BoxDecoration(
                                          color: ColorGlobal.colorPrimary,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              (getWidth(10, 1)),
                                            ),
                                          ),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child:  Text(
                                          "CHANGE PASSWORD",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: getWidth(18, 1),
                                            color: ColorGlobal.whiteColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                StreamBuilder<double>(
                    stream: _bloc.stream,
                    builder: (BuildContext context,
                        AsyncSnapshot<double> snapshot) {
                      print(
                          'is keyboard open: ${_bloc.keyboardUtils.isKeyboardOpen}'
                              'Height: ${_bloc.keyboardUtils.keyboardHeight}');
                      return _bloc.keyboardUtils.isKeyboardOpen == true
                          ? Container(
                        height: _bloc.keyboardUtils.keyboardHeight,
                      )
                          : Container(
                        height: 0,
                        width: 0,
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
