import 'dart:io' show Platform;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iosrecal/routes.dart';

import 'package:iosrecal/bloc/KeyboardBloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:iosrecal/constants/UIUtility.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> with TickerProviderStateMixin{
  String uri;
  final TextEditingController messageController = TextEditingController();
  final Color darkBlue = Color.fromARGB(255, 18, 32, 47);
  UIUtility uiUtills = new UIUtility();
  KeyboardBloc _bloc = new KeyboardBloc();

  AnimationController _animationController;

  double _containerPaddingLeft = 20.0;
  double _animationValue;
  double _translateX = 0;
  double _translateY = 0;
  double _rotate = 0;
  double _scale = 1;

  bool show;
  bool sent = false;
  Color _color = Colors.lightBlue;

  initState() {
    super.initState();
    _bloc.start();
    uiUtills = new UIUtility();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1300));
    show = true;
    _animationController.addListener(() {
      setState(() {
        show = false;
        _animationValue = _animationController.value;
        if (_animationValue >= 0.2 && _animationValue < 0.4) {
          _containerPaddingLeft = 100.0;
          _color = Colors.green;
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
  }
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
  

  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }


  Widget animatedButton(){
    return GestureDetector(

        onTap: () async {
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
                fontSize: getWidth(16, 2));
          }
        },
        child: AnimatedContainer(
            decoration: BoxDecoration(
              color: _color,
              borderRadius: BorderRadius.circular(120),
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
                  child: sent ? Icon(Icons.done, color: Colors.white) : Container(),
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
                  child: sent ? Text("Done", style: TextStyle(color: Colors.white)) : Container(),
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
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: getWidth(16, 2),
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
        _animationController.forward();
        messageController.text = "";
        Future.delayed(const Duration(seconds: 2), () => Navigator.pop(context));
        return true;
      }else if(responseBody.status_code==401){
        onTimeOut();
      }else {
        Fluttertoast.showToast(
          msg: "Error occurred. Please try again later.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: getWidth(16, 2),
        );
        print(responseBody.data);

        return false;
      }
    } else {
      Fluttertoast.showToast(
        msg: "Error occurred. Please try again later.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: getWidth(16, 2),
      );
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
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('Session Timeout'),
        content : Text('Login in continue'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => navigateAndReload(),
            child: Text("OK"),
          ),
        ],
      ),
    ) ??
        false;
  }

  _sendMail() async {
    // Android and iOS
    if(Platform.isAndroid) {
      const uri =
          'mailto:recaluaechapter@gmail.com?subject=Recal UAE Chapter&body=Greetings';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        print("error mail");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    uiUtills.updateScreenDimesion(width: width, height: height);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            backgroundColor: ColorGlobal.whiteColor,
            leading: IconButton(
              icon: Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios, color: ColorGlobal.textColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Contact',
              style: TextStyle(color: ColorGlobal.textColor),
            ),
          ),
          backgroundColor: Colors.white.withOpacity(0.9),
          body: SingleChildScrollView(
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
                      padding: EdgeInsets.fromLTRB(0.0, getHeight(10, 2), getWidth(8, 2), 0.0),
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
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.email,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Platform.isAndroid ?
                                  GestureDetector(
                                    child: Text("Email\nrecaluaechapter@gmail.com", style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    )),
                                    onTap: () async {
                                      if(Platform.isAndroid)
                                        await _sendMail();
                                    },
                                  ) :
                                  CustomToolTip(text: 'Email\nrecaluaechapter@gmail.com'),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.phone_android,
                                      color: Colors.white,
                                    ),
                                  ),
                                  CustomToolTip(text: 'WhatsApp\n+971-55-1086104'),
                                ],
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
                      padding: EdgeInsets.fromLTRB(getWidth(16, 2), getHeight(10, 2), getWidth(16, 2), getHeight(10, 2)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Please write about your issue. Someone from the admin team will respond within 24 hrs.',
                            style: TextStyle(
                              fontSize: getWidth(18, 2),
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
                          animatedButton(),
                          ],
                        ),
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
                          ? SizedBox(
                        height: _bloc.keyboardUtils.keyboardHeight,
                      )
                          : SizedBox();
                    }),
              ],
            ),
          )),
    );
  }
}
class CustomToolTip extends StatelessWidget {

  String text;

  CustomToolTip({this.text});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Text(text, style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      )),
      onTap: () {
        Fluttertoast.showToast(msg: text.contains("@") ?  "Copied Email Address" : "Copied WhatsApp number",textColor: Colors.white,backgroundColor: Colors.green);
        Clipboard.setData(new ClipboardData(text: text.split('\n')[1]));
      },
      onLongPress: () {
        Fluttertoast.showToast(msg: text.contains("@") ?  "Copied Email Address" : "Copied WhatsApp number",textColor: Colors.white,backgroundColor: Colors.green);
        Clipboard.setData(new ClipboardData(text: text.split('\n')[1]));
      },
    );
  }
}

