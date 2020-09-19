import 'dart:io';
import 'dart:convert';
import 'package:iosrecal/Constant/Constant.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:iosrecal/Endpoint/Api.dart';
import 'package:connectivity/connectivity.dart';

class WriteAdmin extends StatefulWidget {
  @override
  AdminState createState() => AdminState();
}

class AdminState extends State<WriteAdmin> with TickerProviderStateMixin{
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
  ProgressDialog pr;
  Future<bool> _sendMessage(String body) async {
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
          fontSize: 16.0);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String url = Api.getSupport;
    final response = await http.post(url, body: {
      "user_id": "${prefs.getString("user_id")}",
      "body": body,
      "type": "write to admin",
    }, headers: {
      "Accept": "application/json",
      "Cookie": "${prefs.getString("cookie")}",
    });

    if (response.statusCode == 200) {
      ResponseBody responseBody =
          ResponseBody.fromJson(json.decode(response.body));
      if (responseBody.status_code == 200) {
        print("worked!");
        Fluttertoast.showToast(
            msg: "Message sent",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        return true;
      }
      else if(responseBody.status_code==401){
        onTimeOut();
      }else {
        print(responseBody.data);
        return false;
      }
    } else {
      print('Server error');
      return false;
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
//      customBody: LinearProgressIndicator(
//        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
//        backgroundColor: Colors.white,
//      ),
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

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    //pr = ProgressDialog(context, type: ProgressDialogType.Normal);

    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xDDFFFFFF),
      appBar: AppBar(
        backgroundColor: ColorGlobal.whiteColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorGlobal.textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Admin Support',
          style: TextStyle(color: ColorGlobal.textColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(
                    width / 12, height / 16, width / 12, 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    AutoSizeText(
                      "NEED ADMIN HELP!!",
                      style: TextStyle(
                          fontSize: 25,
                          color: const Color(0xff3AAFFA),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: height / 64),
                    AutoSizeText(
                      "Please write your message in the box below",
                      style: TextStyle(
                        fontSize: 15,
                        color: const Color(0xff3AAFFA),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      autocorrect: true,
                      maxLines: 8,
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Enter message to admin',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        filled: true,
                        fillColor: Colors.white70,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide:
                              BorderSide(color: Color(0xFF3AAFFA), width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide:
                              BorderSide(color: Color(0xFF3AAFFA), width: 2),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 64,
                    ),
                    animatedButton(),
//                    RawMaterialButton(
//                      onPressed: () async {
//                        final String message = messageController.text;
//                        if (message != "") {
//                          bool b = await _sendMessage(message);
//                          ProgressDialog pr;
//                          if (b) {
//                            _loginDialog1(pr, "Message Sent", "Thank you", 1);
//                          } else {
//                            _loginDialog1(
//                                pr, "Message was not sent", "Try again", 0);
//                          }
//                        } else {
//                          Fluttertoast.showToast(
//                              msg: "Enter a message",
//                              toastLength: Toast.LENGTH_SHORT,
//                              gravity: ToastGravity.BOTTOM,
//                              timeInSecForIosWeb: 1,
//                              backgroundColor: Colors.blue,
//                              textColor: Colors.white,
//                              fontSize: 16.0);
//                        }
//                      },
//                      elevation: 2.0,
//                      fillColor: Colors.blue,
//                      child: Icon(
//                        Icons.send,
//                        color: Colors.white,
//                        size: 30.0,
//                      ),
//                      padding: EdgeInsets.all(15.0),
//                      shape: CircleBorder(),
//                    ),
                    SizedBox(
                      height: height / 64,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Image(
                  height: height / 2.75,
                  width: width,
                  fit: BoxFit.fitWidth,
                  image: AssetImage('assets/images/adminsupport.jpg'),
                  alignment: Alignment.bottomCenter,
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}