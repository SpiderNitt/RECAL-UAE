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


class WriteAdmin extends StatefulWidget {
  @override
  _WriteAdminState createState() => _WriteAdminState();
}

class _WriteAdminState extends State<WriteAdmin> {
  final TextEditingController messageController = TextEditingController();

  Future<bool> _sendMessage(String body) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String url = "https://delta.nitt.edu/recal-uae/api/employment/write_admin";
    final response = await http.post(url, body: {
      "user_id" : "${prefs.getString("user_id")}",
      "body" : body,
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
            'Write to Admin',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                    width: width,
                    height: 0.4*height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff3AAFFA), Color(0xff374ABE)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
//            height : height/2,
//            color: const Color(0xFF2146A8),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: height / 15 + 12),
                        Center(
                          child: Image(
                            image: AssetImage('assets/images/write.png'),
                            height: 2*height / 15 - 24,
                            width: 2*height / 15 - 24,
                          ),
                        ),
                        SizedBox(height: height/15),
                      ],
                    )),
                Container(
                  transform:
                  Matrix4.translationValues(0.0, -2*height / 15 + 12, 0.0),
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
                          RawMaterialButton(
                            onPressed: () async{
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
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

