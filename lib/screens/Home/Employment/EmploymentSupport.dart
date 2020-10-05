import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:iosrecal/routes.dart';
import 'dart:io' show Platform;
import 'package:iosrecal/constants/UIUtility.dart';

class EmploymentSupport extends StatefulWidget {
  @override
  EmploymentSupportState createState() => new EmploymentSupportState();
}

class EmploymentSupportState extends State<EmploymentSupport> {
  UIUtility uiUtills = new UIUtility();

  @override
  void initState(){
    uiUtills = new UIUtility();
  }

  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    uiUtills.updateScreenDimesion(width: width, height: height);

    return (WillPopScope(
        child: SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: ColorGlobal.whiteColor,
                  leading: IconButton(
                      icon: Icon(
                        Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                        color: ColorGlobal.textColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  title: Text(
                    'Employment Support',
                    style: TextStyle(color: ColorGlobal.textColor),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Stack(children: <Widget>[
                    ClipPath(
                        clipper: ClippingClass2(),
                        child: Container(
                          width: width,
                          height: height / 2.5,
                          color: Colors.blue,
                        )),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: ClipPath(
                            child: Container(
                                width: width,
                                height: height / 2.75,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage('assets/images/socialBusiness.jpg'),
                                    ))))),
                    Column(children: <Widget>[
                      SizedBox(
                        height: height / 3.25,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: width / 12,
                          ),
                          GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, OPEN_POSITIONS);
                              },
                              child: Column(
                                children: <Widget>[
                                  Card(
                                    child: Container(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: width / 10,
                                        child: Image.asset(
                                          'assets/images/open_positions.png',
                                          height: width / 10,
                                          width: width / 10,
                                        ),
                                      ),
                                    ),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        new BorderRadius.circular(width / 10)),
                                  ),
                                  SizedBox(height: 6.0),
                                  Container(
                                      child: Column(children: <Widget>[
                                        AutoSizeText(
                                          "Open",
                                          style: TextStyle(
                                              fontSize: getWidth(16, 2),
                                              color: Color(0xFF433d3e),
                                              fontWeight: FontWeight.w600),
                                          maxLines: 1,
                                        ),
                                        AutoSizeText(
                                          "Positions",
                                          style: TextStyle(
                                              fontSize: getWidth(16, 2),
                                              color: Color(0xFF433d3e),
                                              fontWeight: FontWeight.w600),
                                          maxLines: 1,
                                        ),
                                      ])),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              )),
                          SizedBox(
                            width: width / 12,
                          ),
                          GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, CLOSED_POSITIONS);
                              },
                              child: Column(
                                children: <Widget>[
                                  Card(
                                    child: Container(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: width / 10,
                                        child: Image.asset(
                                          'assets/images/closed_positions.png',
                                          height: width / 10,
                                          width: width / 10,
                                        ),
                                      ),
                                    ),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        new BorderRadius.circular(width / 10)),
                                  ),
                                  SizedBox(height: 6.0),
                                  Container(
                                      child: Column(children: <Widget>[
                                        AutoSizeText(
                                          "Closed",
                                          style: TextStyle(
                                              fontSize: getWidth(16, 2),
                                              color: Color(0xFF433d3e),
                                              fontWeight: FontWeight.w600),
                                          maxLines: 1,
                                        ),
                                        AutoSizeText(
                                          "Positions",
                                          style: TextStyle(
                                              fontSize: getWidth(16, 2),
                                              color: Color(0xFF433d3e),
                                              fontWeight: FontWeight.w600),
                                          maxLines: 1,
                                        ),
                                      ])),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              )),
                          SizedBox(
                            width: width / 12,
                          ),
                          GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, MEMBER_LINKEDIN);
                              },
                              child: Column(
                                children: <Widget>[
                                  Card(
                                    child: Container(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: width / 10,
                                        child: Text("in",style: TextStyle(color: Color(int.parse("0xff0076b4")), fontWeight: FontWeight.bold, fontSize: width/10),)
                                      ),
                                    ),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        new BorderRadius.circular(width / 10)),
                                  ),
                                  SizedBox(height: 6.0),
                                  Container(
                                      child: Column(children: <Widget>[
                                        AutoSizeText(
                                          "LinkedIn",
                                          style: TextStyle(
                                              fontSize: getWidth(16, 2),
                                              color: Color(0xFF433d3e),
                                              fontWeight: FontWeight.w600),
                                          maxLines: 1,
                                        ),
                                        AutoSizeText(
                                          "Profiles",
                                          style: TextStyle(
                                              fontSize: getWidth(16, 2),
                                              color: Color(0xFF433d3e),
                                              fontWeight: FontWeight.w600),
                                          maxLines: 1,
                                        ),
                                      ])),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              )),
                          SizedBox(
                            width: width / 16,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height / 24,
                      ),
                      Row(children: <Widget>[
                        SizedBox(
                          width: width / 4,
                        ),
                        GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context, MARKET_SURVEY);
                            },
                            child: Column(
                              children: <Widget>[
                                Card(
                                  child: Container(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: width / 10,
                                      child: Image.asset(
                                        'assets/images/market_survey.png',
                                        height: width / 10,
                                        width: width / 10,
                                      ),
                                    ),
                                  ),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      new BorderRadius.circular(width / 10)),
                                ),
                                SizedBox(height: 6.0),
                                Container(
                                    child: Column(children: <Widget>[
                                      AutoSizeText(
                                        "Market",
                                        style: TextStyle(
                                            fontSize: getWidth(16, 2),
                                            color: Color(0xFF433d3e),
                                            fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                      ),
                                      AutoSizeText(
                                        "Survey",
                                        style: TextStyle(
                                            fontSize: getWidth(16, 2),
                                            color: Color(0xFF433d3e),
                                            fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                      ),
                                    ])),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            )),
                        SizedBox(
                          width: width / 12,
                        ),
                        GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context, WRITE_RESUME_SCREEN);
                            },
                            child: Column(
                              children: <Widget>[
                                Card(
                                  child: Container(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: width / 10,
                                      child: Image.asset(
                                        'assets/images/resume_writing.png',
                                        height: width / 10,
                                        width: width / 10,
                                      ),
                                    ),
                                  ),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      new BorderRadius.circular(width / 10)),
                                ),
                                SizedBox(height: 6.0),
                                Container(
                                    child: Column(children: <Widget>[
                                      AutoSizeText(
                                        "Write",
                                        style: TextStyle(
                                            fontSize: getWidth(16, 2),
                                            color: Color(0xFF433d3e),
                                            fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                      ),
                                      AutoSizeText(
                                        "Resume",
                                        style: TextStyle(
                                            fontSize: getWidth(16, 2),
                                            color: Color(0xFF433d3e),
                                            fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                      ),
                                    ])),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            )),
                        SizedBox(
                          width: width / 12,
                        ),
                      ])
                    ]),
                  ]),
                )))));
  }
}

class ClippingClass2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - size.height / 6);
    path.quadraticBezierTo(size.width - size.width / 4, size.height, size.width,
        size.height - size.height /6);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - size.height / 5);
    path.quadraticBezierTo(size.width / 4, size.height - size.height / 3,
        size.width / 2, size.height - size.height / 5);
    path.quadraticBezierTo(
        size.width - size.width / 4,
        size.height - size.height / 10,
        size.width,
        size.height - size.height / 5);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
