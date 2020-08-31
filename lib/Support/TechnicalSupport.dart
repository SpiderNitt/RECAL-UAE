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

class TechnicalSupport extends StatefulWidget {
  @override
  TechnicalState createState() => TechnicalState();
}

class TechnicalState extends State<TechnicalSupport> {
  final TextEditingController messageController = TextEditingController();

  Future<bool> _sendMessage(String body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String url =
        "https://delta.nitt.edu/recal-uae/api/employment/write_admin";
    final response = await http.post(url, body: {
      "user_id": "${prefs.getString("user_id")}",
      "body": body,
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
      } else {
        print(responseBody.data);
        Fluttertoast.showToast(
            msg: "An error occured. Please try again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
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
          fontSize: 16.0);
    }
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
          'Technical Support',
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
                      "NEED TECHNICAL HELP!!",
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
                        hintText: 'Enter message',
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
                        bool b = await _sendMessage(message);
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
                  image: AssetImage('assets/images/technicalSupport.jpg'),
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
