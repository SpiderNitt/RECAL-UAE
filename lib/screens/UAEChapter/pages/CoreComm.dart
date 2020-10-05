import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iosrecal/routes.dart';
import 'package:iosrecal/models/CoreCommModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/widgets/NoData.dart';
import 'package:iosrecal/widgets/Error.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/constants/Api.dart';
import 'package:connectivity/connectivity.dart';
import 'package:iosrecal/widgets/NoInternet.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iosrecal/constants/UIUtility.dart';

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
  int internet = 1;
  bool error = false;
  var state = 0;
  static List<String> _members = [];
  String tenure, date;
  int flag = 0;
  UIUtility uiUtills = new UIUtility();

  Future<CoreCommModel> _corecomm() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        internet = 0;
      });
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
          fontSize: 16,
        );
      }
    }
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
            responseBody.data['tenure'] != null
                ? tenure = responseBody.data['tenure']
                : print("empty tenure");
            responseBody.data['date'] != null
                ? date = responseBody.data['date']
                : print("empty date");

            if (tenure != null) print(tenure);
            if (date != null) print(date);
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
        } else if (responseBody.status_code == 401) {
          onTimeOut();
        } else {
          setState(() {
            error = true;
          });
        }
      } else {
        setState(() {
          flag = 2;
          error = true;
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
    uiUtills = new UIUtility();
  }

  Future<bool> _onBackPressed() {
    Navigator.of(context).pop(true);
  }

  Future<bool> onTimeOut() {
    return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => new AlertDialog(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: new Text('Session Timeout'),
            content: new Text('Login to continue'),
            actions: <Widget>[
              FlatButton(
                onPressed: () async {
                  navigateAndReload();
                },
                child: Text("OK"),
              ),
            ],
          ),
        ) ??
        false;
  }

  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }

  navigateAndReload() {
    Navigator.pushNamed(context, LOGIN_SCREEN, arguments: true).then((value) {
      Navigator.pop(context);
      setState(() {});
      _corecomm();
    });
  }

  refresh() {
    setState(() {
      state = 0;
      internet = 1;
      error = false;
    });
    _corecomm();
  }

  Widget getBody() {
    if (internet == 0) {
      return NoInternetScreen(notifyParent: refresh);
    } else if (flag == 0) {
      return SpinKitDoubleBounce(
        color: ColorGlobal.blueColor,
      );
    } else if (flag == 1 && error == false) {
      final size = MediaQuery.of(context).size;
      final refHeight = 700.666;
      final refWidth = 360;
      return Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
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
                  ? Column(children: <Widget>[
                      Text(
                        "The ongoing members of the core committee of RECAL UAE Chapter are as follows:",
                        style: TextStyle(
                          color: Color(0xFF544F50),
                          fontSize: getWidth(15, 3),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "\nPresident:",
                        style: TextStyle(
                          color: Color(0xFF544F50),
                          fontSize: getWidth(18, 3),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "${_members[0]}",
                        style: TextStyle(
                          color: Color(0xFF544F50),
                          fontSize: getWidth(15, 3),
                          // fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "\nVice President:",
                        style: TextStyle(
                          color: Color(0xFF544F50),
                          fontSize: getWidth(18, 3),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "${_members[1]}",
                        style: TextStyle(
                          color: Color(0xFF544F50),
                          fontSize: getWidth(15, 3),
                          //fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "\nSecretary:",
                        style: TextStyle(
                          color: Color(0xFF544F50),
                          fontSize: getWidth(18, 3),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "${_members[2]}",
                        style: TextStyle(
                          color: Color(0xFF544F50),
                          fontSize: getWidth(15, 3),
                          //fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "\nJoint Secretary:",
                        style: TextStyle(
                          color: Color(0xFF544F50),
                          fontSize: getWidth(18, 3),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "${_members[3]}",
                        style: TextStyle(
                          color: Color(0xFF544F50),
                          fontSize: getWidth(15, 3),
                          //fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "\nTreasurer:",
                        style: TextStyle(
                          color: Color(0xFF544F50),
                          fontSize: getWidth(18, 3),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "${_members[4]}",
                        style: TextStyle(
                          color: Color(0xFF544F50),
                          fontSize: getWidth(15, 3),
                          //fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "\nVMentor 1:",
                        style: TextStyle(
                          color: Color(0xFF544F50),
                          fontSize: getWidth(18, 3),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "${_members[5]}",
                        style: TextStyle(
                          color: Color(0xFF544F50),
                          fontSize: getWidth(15, 3),
                          //fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "\nMentor 2:",
                        style: TextStyle(
                          color: Color(0xFF544F50),
                          fontSize: getWidth(18, 3),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "${_members[5]}",
                        style: TextStyle(
                          color: Color(0xFF544F50),
                          fontSize: getWidth(15, 3),
                          //fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ])
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
      );
    } else if (flag == 2 && error == false) {
      return NodataScreen();
    } else {
      return Error8Screen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    uiUtills.updateScreenDimesion(width: width, height: height);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: ColorGlobal.whiteColor,
              leading: (Platform.isAndroid)
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: ColorGlobal.textColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                  : IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: ColorGlobal.textColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
              title: Text(
                'Core Committee',
                style: TextStyle(color: ColorGlobal.textColor),
              ),
            ),
            body: getBody()),
      ),
    );
  }
}
