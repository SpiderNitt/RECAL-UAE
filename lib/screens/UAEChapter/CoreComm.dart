import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iosrecal/models/CoreCommModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/Endpoint/Api.dart';

class CoreComm extends StatefulWidget {
  @override
  CoreCommState createState() {
    return new CoreCommState();
  }
}

class CoreCommState extends State<CoreComm> {
  var top = FractionalOffset.topCenter;
  var bottom = FractionalOffset.bottomCenter;
  double width = 220.0;
  double widthIcon = 200.0;
  static List<String> _members = [];
  int flag = 0;
  Future<CoreCommModel> _corecomm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await http.get(Api.chapterCore, headers: {
      "Accept": "application/json",
      "Cookie": "${prefs.getString("cookie")}",
    }).then((_response) {
      ResponseBody responseBody = new ResponseBody();
      print('Response body: ${_response.body}');
      if (_response.statusCode == 200) {
        responseBody = ResponseBody.fromJson(json.decode(_response.body));
        if (responseBody.status_code == 200) {
          if (responseBody.data != null) {
            responseBody.data['president'] != null
                ? _members.add(responseBody.data['president'])
                : print("empty");
            responseBody.data['vice_president'] != null
                ? _members.add(responseBody.data['vice_president'])
                : print("empty");
            responseBody.data['secretary'] != null
                ? _members.add(responseBody.data['secretary'])
                : print("empty");
            responseBody.data['joint_secretary'] != null
                ? _members.add(responseBody.data['joint_secretary'])
                : print("empty");
            responseBody.data['treasurer'] != null
                ? _members.add(responseBody.data['treasurer'])
                : print("empty");
            responseBody.data['mentor1'] != null
                ? _members.add(responseBody.data['mentor1'])
                : print("empty");
            responseBody.data['mentor2'] != null
                ? _members.add(responseBody.data['mentor2'])
                : print("empty");
            if (_members.length > 0)
              setState(() {
                flag = 1;
              });
            else
              setState(() {
                flag = 2;
              });

            print("members: ");
            print(_members);
          }
        } else {
          setState(() {
            flag = 2;
          });
          print(responseBody.data);
        }
      } else {
        setState(() {
          flag = 2;
        });
        print('Server error');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Core Committee");
    _corecomm();
  }

  Future<bool> _onBackPressed() {
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final refHeight = 700.666;
    final refWidth = 360;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: ColorGlobal.whiteColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: ColorGlobal.textColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'Core Committee',
                style: TextStyle(color: ColorGlobal.textColor),
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                      colors: [
                        Color(0xFF9CD7FC),
                        Colors.blue.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFEAE3E3),
                        spreadRadius: 2,
                        blurRadius: 0,
                        // changes position of shadow
                      ),
                    ],
                    border: Border.all(
                      width: 2,
                      color: Color(
                          0xFF544F50), //                   <--- border width here
                    ),
                    color: Color(0xFF544F50),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        (22.0),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: flag == 1
                        ? Text(
                            "The ongoing members of the core committee of RECAL UAE Chapter are functioning since Oct 2019. The member details are as follows:"
                            "\n\nPresident:\n ${_members[0]} "
                            "\n\nVice President:\n ${_members[1]} "
                            "\n\nSecretary:\n ${_members[2]} "
                            "\n\nJoint Secretary:\n ${_members[3]} "
                            "\n\nTreasurer:\n ${_members[4]} "
                            "\n\nMentor 1:\n ${_members[5]} "
                            "\n\nMentor 2:\n ${_members[6]} ",
                            style: TextStyle(
                              color: Color(0xFF544F50),
                              fontSize: 15.0 * (size.width) / refWidth,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            "Error loading data, Please try again",
                            style: TextStyle(
                              color: Color(0xFF544F50),
                              fontSize: 15.0 * (size.width) / refWidth,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
