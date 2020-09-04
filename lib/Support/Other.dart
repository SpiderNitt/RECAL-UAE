import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constant/ColorGlobal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:progress_dialog/progress_dialog.dart';

class OtherScreen extends StatefulWidget {
  @override
  OtherState createState() => OtherState();
}

class OtherState extends State<OtherScreen> {
  final TextEditingController messageController = TextEditingController();

  Future<bool> _sendMessage(String body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String url =
        "https://delta.nitt.edu/recal-uae/api/employment/support";
    final response = await http.post(url, body: {
      "user_id": "${prefs.getString("user_id")}",
      "body": body,
      "type": "others",
    }, headers: {
      "Accept": "application/json",
      "Cookie": "${prefs.getString("cookie")}",
    });

    if (response.statusCode == 200) {
      ResponseBody responseBody =
          ResponseBody.fromJson(json.decode(response.body));
      if (responseBody.status_code == 200) {
        print("worked!");
        return true;
      } else {
        print(responseBody.data);
        return false;
      }
    } else {
      print('Server error');
      return false;
    }
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

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
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
          'Other',
          style: TextStyle(color: ColorGlobal.textColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(
                    width / 12, height / 16, width / 12, 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "HAVE A QUERY!!",
                      style: TextStyle(
                          fontSize: 25,
                          color: const Color(0xff3AAFFA),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: height / 64),
                    Text(
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
                      maxLines: 5,
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Enter details',
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
                    RawMaterialButton(
                      onPressed: () async {
                        final String message = messageController.text;
                        if (message != "") {
                          bool b = await _sendMessage(message);
                          ProgressDialog pr;
                          if (b) {
                            _loginDialog1(pr, "Message Sent", "Thank you", 1);
                          } else {
                            _loginDialog1(
                                pr, "Message was not sent", "Try again", 0);
                          }
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
                      elevation: 2.0,
                      fillColor: Colors.blue,
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                    ),
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
                  image: AssetImage('assets/images/seek_guidance_bottom.jpg'),
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
