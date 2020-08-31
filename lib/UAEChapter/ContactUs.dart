import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import '../Constant/ColorGlobal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  String uri;
  final TextEditingController messageController = TextEditingController();

  Future<bool> _sendMessage(String body) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String url = "https://delta.nitt.edu/recal-uae/api/feedback/send";
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

  _sendMail() async {
    // Android and iOS
    const uri =
        'mailto:recaluaechapter@gmail.com?subject=Recal UAE Chapter&body=Greetings';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
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
                                        'Phone\n+971-55-1086104',
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
                            RawMaterialButton(
                              onPressed: () {
                                _sendMessage(messageController.text);
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
          )),
    );
  }
}

