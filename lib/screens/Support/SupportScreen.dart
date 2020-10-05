import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/routes.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'pages/WriteAdmin.dart';
import 'package:iosrecal/constants/UIUtility.dart';
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       home: new SupportScreen(),
//     );
//   }
// }

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key key}) : super(key: key);

  @override
  SupportScreenState createState() => new SupportScreenState();
}

class SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    print(width);
    print(height);
    UIUtility().updateScreenDimesion(width: width, height: height);
    print(UIUtility()
        .getProportionalWidth(
        width: 16, choice: 3));
    return (
        WillPopScope(
        child: SafeArea(
            child: new Scaffold(
                backgroundColor: ColorGlobal.whiteColor,
                appBar: AppBar(
                  backgroundColor: ColorGlobal.whiteColor,
                  centerTitle: true,
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'SUPPORT',
                        style: GoogleFonts.josefinSans(
                            color: ColorGlobal.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: UIUtility().getProportionalWidth(width: 20,choice: 1)),
                      ),
                    ],
                  ),
                ),
                body: Stack(children: <Widget>[
                  ClipPath(
                      clipper: ClippingClass2(),
                      child: Container(
                        width: width,
                        height: height / 2.5,
                        color: ColorGlobal.blueColor,
                      )),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: ClipPath(
                          clipper: ClippingClass(),
                          child: Container(
                              width: width,
                              height: height / 2.75,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/images/newSupportbg.jpg'),
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
                          child: Column(
                            children: <Widget>[
                              Card(
                                child: Container(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: width / 10,
                                    child: Image.asset(
                                      'assets/images/pencil.png',
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
//                                    alignment: Alignment.center,
                                  child: Column(children: <Widget>[
                                AutoSizeText(
                                  "Write to",
                                  style: TextStyle(
                                      fontSize:  UIUtility()
                                          .getProportionalWidth(
                                          width: 16, choice: 3),
                                      color: Color(0xFF433d3e),
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                ),
                                AutoSizeText(
                                  "admin",
                                  style: TextStyle(
                                      fontSize:  UIUtility()
                                          .getProportionalWidth(
                                          width: 16, choice: 3),
                                      color: Color(0xFF433d3e),
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                ),
                              ])),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, WRITE_TO_ADMIN);
                          },
                        ),
                        SizedBox(
                          width: width / 12,
                        ),
                        GestureDetector(
                          child: Column(
                            children: <Widget>[
                              Card(
                                child: Container(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: width / 10,
                                    child: Image.asset(
                                      'assets/images/mentor.png',
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
//                                    alignment: Alignment.center,
                                  child: Column(children: <Widget>[
                                AutoSizeText(
                                  "Write to",
                                  style: TextStyle(
                                      fontSize:  UIUtility()
                                          .getProportionalWidth(
                                          width: 16, choice: 3),
                                      color: Color(0xFF433d3e),
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                ),
                                AutoSizeText(
                                  "mentor",
                                  style: TextStyle(
                                      fontSize:  UIUtility()
                                          .getProportionalWidth(
                                          width: 16, choice: 3),
                                      color: Color(0xFF433d3e),
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                ),
                              ])),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, WRITE_MENTOR);
                          },
                        ),
                        SizedBox(
                          width: width / 12,
                        ),
                        GestureDetector(
                          child: Column(
                            children: <Widget>[
                              Card(
                                child: Container(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: width / 10,
                                    child: Image.asset(
                                      'assets/images/technical.png',
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
//                                    alignment: Alignment.center,
                                  child: Column(children: <Widget>[
                                AutoSizeText(
                                  "Technical",
                                  style: TextStyle(
                                      fontSize:  UIUtility()
                                          .getProportionalWidth(
                                          width: 16, choice: 3),
                                      color: Color(0xFF433d3e),
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                ),
                                AutoSizeText(
                                  "Support",
                                  style: TextStyle(
                                      fontSize: UIUtility()
                                          .getProportionalWidth(
                                          width: 16, choice: 3),
                                      color: Color(0xFF433d3e),
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                ),
                              ])),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, TECHNICAL_SUPPORT);
                          },
                        ),
                        SizedBox(
                          width: width / 16,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height / 24,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: width / 12,
                        ),
                        GestureDetector(
                          child: Column(
                            children: <Widget>[
                              Card(
                                child: Container(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: width / 10,
                                    child: Image.asset(
                                      'assets/images/volunteer.png',
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
//                                    alignment: Alignment.center,
                                  child: Column(children: <Widget>[
                                AutoSizeText(
                                  "Vounteer",
                                  style: TextStyle(
                                      fontSize: UIUtility()
                                          .getProportionalWidth(
                                              width: 16, choice: 3),
                                      color: Color(0xFF433d3e),
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                ),
                              ])),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, VOLUNTEER_SUPPORT);
                          },
                        ),
                        SizedBox(
                          width: width / 12,
                        ),
                        GestureDetector(
                          child: Column(
                            children: <Widget>[
                              Card(
                                child: Container(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: width / 10,
                                    child: Image.asset(
                                      'assets/images/review.png',
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
//                                    alignment: Alignment.center,
                                  child: Column(children: <Widget>[
                                AutoSizeText(
                                  "Feedback",
                                  style: TextStyle(
                                      fontSize:  UIUtility()
                                          .getProportionalWidth(
                                          width: 16, choice: 3),
                                      color: Color(0xFF433d3e),
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                ),
                              ])),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, FEEDBACK_SUPPORT);
                          },
                        ),
                        SizedBox(
                          width: width / 12,
                        ),
                        GestureDetector(
                          child: Column(
                            children: <Widget>[
                              Card(
                                child: Container(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: width / 10,
                                    child: Image.asset(
                                      'assets/images/other.png',
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
//                                    alignment: Alignment.center,
                                  child: Column(children: <Widget>[
                                AutoSizeText(
                                  "Other",
                                  style: TextStyle(
                                      fontSize:  UIUtility()
                                          .getProportionalWidth(
                                          width: 16, choice: 3),
                                      color: Color(0xFF433d3e),
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                ),
                              ])),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, OTHER_SUPPORT);
                          },
                        ),
                        SizedBox(
                          width: width / 16,
                        ),
                      ],
                    ),
                  ]),
                ])))));
  }
}

class ClippingClass2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - size.height / 6);
    path.quadraticBezierTo(size.width - size.width / 4, size.height, size.width,
        size.height - size.height / 6);

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
