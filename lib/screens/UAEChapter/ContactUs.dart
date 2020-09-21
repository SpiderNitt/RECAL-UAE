import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iosrecal/Constant/Constant.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:progress_dialog/progress_dialog.dart';


class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> with TickerProviderStateMixin{
  String uri;
  final TextEditingController messageController = TextEditingController();
  final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

  AnimationController _animationController;

  double _containerPaddingLeft = 20.0;
  double _animationValue;
  double _translateX = 0;
  double _translateY = 0;
  double _rotate = 0;
  double _scale = 1;

  bool show;
  bool sent = false;
  bool error = false;
  Color _color = Colors.lightBlue;

  initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1300));
    show = true;
    _animationController.addListener(() {
      setState(() {
        show = false;
        _animationValue = _animationController.value;
        if (_animationValue >= 0.2 && _animationValue < 0.4) {
          _containerPaddingLeft = 100.0;
          _color = error ? Colors.red : Colors.green;
        } else if (_animationValue >= 0.4 && _animationValue <= 0.5) {
          _translateX = 80.0;
          _rotate = -20.0;
          _scale = 0.1;
        } else if (_animationValue >= 0.5 && _animationValue <= 0.8) {
          _translateY = -20.0;
        } else if (_animationValue >= 0.81) {
          _containerPaddingLeft = 20.0;
          sent = true;
        }
      });
    });
    //_positions();
  }

  Widget animatedButton(){
    return GestureDetector(

        onTap: () async {
          _animationController.forward();

          final String message = messageController.text;
          if (message != "") {
            bool b = await _sendMessage(message);
          } else {
            Fluttertoast.showToast(
                msg: "Enter a message",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
        child: AnimatedContainer(
            decoration: BoxDecoration(
              color: _color,
              borderRadius: BorderRadius.circular(120.0),
              boxShadow: [
                BoxShadow(
                  color: _color,
                  blurRadius: 21,
                  spreadRadius: -15,
                  offset: Offset(
                    0.0,
                    20.0,
                  ),
                )
              ],
            ),
            padding: EdgeInsets.only(
                left: _containerPaddingLeft,
                right: 20.0,
                top: 20.0,
                bottom: 20.0),
            duration: Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                (!sent)
                    ? AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  child: Icon(Icons.send, color: Colors.white),
                  curve: Curves.fastOutSlowIn,
                  transform: Matrix4.translationValues(
                      _translateX, _translateY, 0)
                    ..rotateZ(_rotate)
                    ..scale(_scale),
                )
                    : Container(),
                AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 600),
                  child: show ? SizedBox(width: 10.0) : Container(),
                ),
                AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 200),
                  child: show ? Text("Send", style: TextStyle(color: Colors.white),) : Container(),
                ),
                AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 200),
                  child: sent ? (error ? Icon(Icons.warning, color: Colors.white) : Icon(Icons.done, color: Colors.white)) : Container(),
                ),
                AnimatedSize(
                  vsync: this,
                  alignment: Alignment.topLeft,
                  duration: Duration(milliseconds: 600),
                  child: sent ? SizedBox(width: 10.0) : Container(),
                ),
                AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 200),
                  child: sent ? (error ? Text("Error", style: TextStyle(color: Colors.white)) : Text("Done", style: TextStyle(color: Colors.white))) : Container(),
                ),
              ],
            )));
  }


  Future<bool> _sendMessage(String body) async{
    FocusScope.of(context).unfocus();
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(
          msg: "Please connect to internet",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String url = "https://delta.nitt.edu/recal-uae/api/employment/support";
    final response = await http.post(url, body: {
      "user_id" : "${prefs.getString("user_id")}",
      "body" : body,
      "type" : "feedback",
    }, headers: {
      "Accept": "application/json",
      "Cookie": "${prefs.getString("cookie")}",
    });

    if(response.statusCode==200){
      ResponseBody responseBody = ResponseBody.fromJson(
          json.decode(response.body));
      if (responseBody.status_code == 200){
        print("worked!");
        Fluttertoast.showToast(
            msg: "Message sent",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
        return true;
      }else if(responseBody.status_code==401){
        onTimeOut();
      }else {
        print(responseBody.data);
        Fluttertoast.showToast(
            msg: "An error occured. Please try again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    } else {
      print('Server error');
      Fluttertoast.showToast(
          msg: "An error occured. Please try again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  navigateAndReload(){
    Navigator.pushNamed(context, LOGIN_SCREEN, arguments: true)
        .then((value) {
      print("step 1");
      Navigator.pop(context);
      });
  }

  Future<bool> onTimeOut(){
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Session Timeout'),
        content: new Text('Login to continue'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () async {
              navigateAndReload();
            },
            child: FlatButton(
              color: Colors.red,
              child: Text("OK"),
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
    );

    pr.style(
      message: "Sending message",
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

  _sendMail() async {
    // Android and iOS
    const uri =
        'mailto:recaluaechapter@gmail.com?subject=Recal UAE Chapter&body=Greetings';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorGlobal.whiteColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: ColorGlobal.textColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Contact',
              style: TextStyle(color: ColorGlobal.textColor),
            ),
          ),
          backgroundColor: Color(0xDDFFFFFF),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                      width: width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xff3AAFFA), Color(0xff374ABE)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
//            height : height/2,
//            color: const Color(0xFF2146A8),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 8.0, 0.0),
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage('assets/images/telephone.png'),
                                height: width / 4,
                                width: width / 3,
                              ),
                            ),
                            SizedBox(height: width / 12),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: Platform.isAndroid ?   _sendMail : null,
                                  child: Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          Icons.email,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Email\nrecaluaechapter@gmail.com',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    uri = "tel://551086104'";
                                    launch(uri);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          Icons.phone_android,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'WhatsApp\n+971-55-1086104',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: width / 6),
                          ],
                        ),
                      )),
                  Container(
                    transform:
                    Matrix4.translationValues(0.0, -width / 6 + 12.0, 0.0),
                    child: Container(
                      width: width - 24,
                      height: width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 10, 8.0, 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Please write about your issue. Someone from the admin team will respond within 24 hrs.',
                              style: TextStyle(
                                fontSize: 18.0,
                                letterSpacing: 1.2,
                                color: Colors.black,
                              ),
                            ),
                            TextField(
                              controller: messageController,
                              autocorrect: true,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: 'Enter message to admin',
                                hintStyle: TextStyle(color: Colors.grey[500]),
                                filled: true,
                                fillColor: Colors.white70,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(
                                      color: Color(0xFF3AAFFA), width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(
                                      color: Color(0xFF3AAFFA), width: 2),
                                ),
                              ),
                            ),
//                            RawMaterialButton(
//                              onPressed: () async {
//                                final String message = messageController.text;
//                                if (message != "") {
//                                  bool b = await _sendMessage(message);
//                                  ProgressDialog pr;
//                                  if (b) {
//                                    _loginDialog1(pr, "Message Sent", "Thank you", 1);
//                                  } else {
//                                    _loginDialog1(
//                                        pr, "Message was not sent", "Try again", 0);
//                                  }
//                                } else {
//                                  Fluttertoast.showToast(
//                                      msg: "Enter a message",
//                                      toastLength: Toast.LENGTH_SHORT,
//                                      gravity: ToastGravity.BOTTOM,
//                                      timeInSecForIosWeb: 1,
//                                      backgroundColor: Colors.blue,
//                                      textColor: Colors.white,
//                                      fontSize: 16.0);
//                                }
//                              },
//                              elevation: 2.0,
//                              fillColor: Colors.blue,
//                              child: Icon(
//                                Icons.send,
//                                color: Colors.white,
//                                size: 30.0,
//                              ),
//                              padding: EdgeInsets.all(15.0),
//                              shape: CircleBorder(),
//                            )
                          animatedButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

