import 'dart:io';

import 'package:flutter/material.dart';
import '../Constant/Constant.dart';
import 'package:page_transition/page_transition.dart';
import '../Constant/ColorGlobal.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../Constant/TextField.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class SignUp extends StatefulWidget {


  @override
  SignUpState createState() {
    return new SignUpState();
  }
}

class SignUpState extends State<SignUp> {

  var top = FractionalOffset.topCenter;
  var bottom = FractionalOffset.bottomCenter;
  double width = 400.0;
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController(text: "");
  TextEditingController password = new TextEditingController();
  Color emailColor = ColorGlobal.textColor;

  FocusNode nameFocus = new FocusNode();
  FocusNode emailFocus = new FocusNode();
  FocusNode passwordFocus = new FocusNode();

  var list = [
    Colors.lightGreen,
    Colors.redAccent,
  ];
  static Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
  bool isValidEmail(input) {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(input);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Branch.year=-1;
    Branch.branch="";
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        width = _textSize("Have an account?",
            TextStyle(
              fontSize: 14,
              letterSpacing: 1,
              color:
              ColorGlobal.whiteColor.withOpacity(0.9),
              fontWeight: FontWeight.w400,
            )
        ).width + 50;
      });
    });
  }
  _signinDialog(String show, String again, int flag) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: Text('Sign In Check'),
        content: new Text(show),
        actions: <Widget>[
          new GestureDetector(
            onTap: () {
              flag != 1
                  ? Navigator.of(context).pop(false)
                  : Navigator.pushReplacementNamed(context, LOGIN_SCREEN);
            },
            child: FlatButton(
              color: Colors.green,
              child: Text(again),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final accountSize = _textSize("Have an account?",
        TextStyle(
          fontSize: 14,
          letterSpacing: 1,
          color:
          ColorGlobal.whiteColor.withOpacity(0.9),
          fontWeight: FontWeight.w400,
        )
    ).width + 50;

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorGlobal.whiteColor,
        body: SingleChildScrollView(
          child: Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(),
                  height: size.height-90,
                  color: ColorGlobal.whiteColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0,bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      ClipRRect(
                        child: Image.asset(
                          'assets/images/nitt_logo.png',
                          height: 90,
                          width: 90,
                        ),
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 130.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Create Account',
                        style: TextStyle(
                          color: ColorGlobal.colorPrimary,
                          fontSize: 20.0,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 22,
                    left: 22,
                    top: 180,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        child: TextFieldWidget(
                          hintText: 'Name',
                          obscureText: false,
                          prefixIconData: Icons.account_circle,
                          textEditingController: name,
                          focusNode: nameFocus,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row (
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container (
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                  color: ColorGlobal.colorPrimary, style: BorderStyle.solid, width: 1),
                            ),
                              child: Branch(select: 0),
                          ),
                          Container (
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                  color: ColorGlobal.colorPrimary, style: BorderStyle.solid, width: 1),
                            ),
                            child: Branch(select: 1),
                          ),

                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: TextFieldWidget(
                          hintText: 'Email',
                          obscureText: false,
                          prefixIconData: Icons.email,
                          textEditingController: email,
                          borderColor: emailColor,
                          focusNode: emailFocus,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: TextFieldWidget(
                          hintText: 'Password',
                          obscureText: true,
                          prefixIconData: Icons.lock,
                          focusNode: passwordFocus,
                          textEditingController: password,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          print(Branch.year);
                          if(email.text!="" && password.text!="" && name.text!="" && Branch.branch!="" && Branch.year!=-1) {
                            if(isValidEmail(email.text)) {
                              var url =
                                  "https://delta.nitt.edu/recal-uae/api/users/add/";
                              Map<String, String> body = <String,String> {
                                'email': email.text,
                                'password': password.text,
                                'name' : name.text,
                                'branch' : Branch.branch,
                                'year' : Branch.year.toString(),
                                'mobile_no': "1234567890",
                                'organization' : "none",
                                'position' : "none",
                                'gender' : "F",
                                'linkedIn' : "none",
                                'is_admin' : "0",
                                'emirate' : "Abu Dhabi",
                              };
//                              Map<String, String> headers = {
//                                "authorization" : "Basic Og==",
//                                'content-type': 'multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW'
//                              };
                              var request =  http.MultipartRequest(
                                'POST',
                                Uri.parse(url)
                          )..fields.addAll(body);
                              var response = await request.send().then((_response) async {
                                print(_response.headers);
                                final respStr = await _response.stream.bytesToString();
                                print("Status ${_response.statusCode}");
                                print(jsonDecode(respStr));
                                if (_response.statusCode == 200) {


                                }
                                else {
                                  print("server error");
                                  _signinDialog(
                                      "Server Error", "Try again", 0);
                                }
                              }).catchError((error) {
                                print('${error ?? "Empty"}');
                                _signinDialog(
                                    '${error ?? "Empty"}', "Try again", 0);
                              });
                            }
                            else {
                              setState(() {
                                emailColor = Colors.red;
                              });
                              _signinDialog("Enter valid email", "Try again", 2);
                            }
                          }
                          else {
                            _signinDialog("Enter all fields", "Try again", 2);
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            top: (20),
                            right: (8),
                            left: (8),
                            bottom: (20),
                          ),
                          height: (60.0),
                          decoration: BoxDecoration(
                            gradient: new LinearGradient(
                              colors: [
                                ColorGlobal.colorPrimary,
                                ColorGlobal.colorPrimary.withOpacity(0.7),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: ColorGlobal.colorPrimary,
                                spreadRadius: 5,
                                blurRadius: 0,
                                // changes position of shadow
                              ),
                            ],
                            border: Border.all(
                              width: 2,
                              color: ColorGlobal
                                  .colorPrimary,
                            ),
                            color: ColorGlobal.whiteColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                (22.0),
                              ),
                            ),
                          ),
                          child: Container(
//                        margin: EdgeInsets.only(left: (10)),
                            alignment: Alignment.center,
                            child: Text(
                              "SIGN UP",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                letterSpacing: 1,
                                color: ColorGlobal.whiteColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: ColorGlobal.whiteColor,
          height: 70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(
                          context,
                          PageTransition(
                            type: PageTransitionType.leftToRight,
                            duration: Duration(milliseconds: 300),
                          ));
                      setState(() {
                        width = screenWidth;
                      });
                    },
                    child: AnimatedContainer(
                      height: 65.0,
                      width: width,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear,
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
//                          margin: EdgeInsets.only(right: 8,top: 15),
                                  child: Text(
                                    "Have an account?",
                                    style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 1,
                                      color:
                                          ColorGlobal.whiteColor.withOpacity(0.9),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
//                          margin: EdgeInsets.only(right: 8,top: 15),
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                      fontSize: 16,
                                      letterSpacing: 1,
                                      color:
                                          ColorGlobal.whiteColor.withOpacity(0.9),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: ColorGlobal.whiteColor,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        color: ColorGlobal.colorPrimary,
                      ),
                    ),
                  ),
              ]
          ),
          ),
      ),
    );
  }
}
// ignore: must_be_immutable
class Branch extends StatefulWidget {

  final int select;
  static String branch;
  static int year;
  Branch({Key key, this.select}) : super(key: key);



  @override
  _BranchState createState() => _BranchState();
}

class _BranchState extends State<Branch> {
  String _branch;
  int _year;
  List <int> all = new List<int>();

  List<int> getYears() {
    all = new List<int>();
    for(var i=2019;i>=1964;i--)
      all.add(i);
    return all;
  }
  List <String> getBranches() {
    return [
      'CSE',
      'ECE',
      'EEE',
      'MECH',
      'PROD',
      'ICE',
      'CHEM',
      'CIVIL',
      'META',
      'ARCHI',
      'PhD/MSc/MS',
      'M.DOMS',
      'MCA',
      'MTECH'
    ];

  }

  @override
  Widget build(BuildContext context) {
//    print('${widget.select}\n');
//    print(_branch);
//    print(all);
    if(widget.select==0) {
      return DropdownButton<String>(
        hint: Text('Branch'),
        value: _branch,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: ColorGlobal.textColor,fontWeight: FontWeight.w600,fontSize: 16.0),
        onChanged: (String newValue) {
          setState(() {
            _branch = newValue;
          });
          Branch.branch = newValue;
        },
        items: getBranches().map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    }
    else {
          return DropdownButton<int>(
            hint: Text('Year of Passing'),
            value: _year,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: ColorGlobal.textColor,fontWeight: FontWeight.w600,fontSize: 16.0),
              onChanged: (int newValue) {
              setState(() {
              _year = newValue;
              });
              Branch.year = newValue;
              },
              items: getYears().map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
              value: value,
              child: Text("$value"),
              );
              }).toList(),
            );

    }
    }

  }

