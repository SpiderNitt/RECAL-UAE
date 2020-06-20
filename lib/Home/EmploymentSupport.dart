import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../Constant/Constant.dart';
import '../Constant/Constant.dart';
import '../Constant/Constant.dart';
import '../Constant/Constant.dart';
import '../Constant/Constant.dart';

class EmploymentSupport extends StatefulWidget {
  @override
  _EmploymentSupportState createState() => _EmploymentSupportState();
}

class _EmploymentSupportState extends State<EmploymentSupport> {
  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  Future<bool> _resumeOptions() {
    return showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
        title: new Text('Choose Action'),
        content: new Text('Do you want to upload CV or write resume'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: FlatButton(
              color: Colors.blueAccent,
              child: Text("Upload CV"),
            ),
          ),
          new GestureDetector(
            onTap: () {
              Navigator.of(context).pop(false);
              Navigator.pushNamed(context, WRITE_RESUME_SCREEN);
            },
            child: FlatButton(
              color: Colors.blueAccent,
              child: Text("Write Resume"),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Employment Support'),
          backgroundColor: const Color(0xFF3AAFFA),

        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Card(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            8.0, 12.0, 8.0, 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              child: Column(
                                children: <Widget>[
                                  Card(
                                    child: Container(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: width / 10,
                                        child: Image.asset(
                                          'assets/images/curriculum.png',
                                          height: width / 10,
                                          width: width / 10,
                                        ),
                                      ),
                                    ),
                                    elevation: 20,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(
                                            width / 10)),
                                  ),
                                  SizedBox(height: 6.0),
                                  Container(
//                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      "Upload/Write CV",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0xFF433d3e),
                                          fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                    ),
                                  ),
//                        Text(
//                          "Upload/Write CV",
//                          style: TextStyle(
//                              fontFamily: 'Pacifico',
//                              fontSize: 15,
//                              fontWeight: FontWeight.bold,
//                              color: Colors.black26),
//                        ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                              onTap: () {
//                                Navigator.pushNamed(context,SOCIAL_BUSINESS);
                                _resumeOptions();
                              },
                            ),
                            GestureDetector(
                              child: Column(
                                children: <Widget>[
                                  Card(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: width / 10,
                                      child: Image.asset(
                                        'assets/images/open_positions.png',
                                        height: width / 10,
                                        width: width / 10,
                                      ),
                                    ),
                                    elevation: 20,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(
                                            width / 10)),
                                  ),
                                  SizedBox(height: 6.0),
                                  Container(
//                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      "Open Positions",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0xFF433d3e),
                                          fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                    ),
                                  ),
//                        Text(
//                          "Open Positions",
//                          style: TextStyle(
//                              fontFamily: 'Pacifico',
//                              fontSize: 15,
//                              fontWeight: FontWeight.bold,
//                              color: Colors.black26),
//                        ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                              onTap: () {
                                Navigator.pushNamed(context,OPEN_POSITIONS);
                              },
                            ),
                            GestureDetector(
                              child: Column(
                                children: <Widget>[
                                  Card(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: width / 10,
                                      child: Image.asset(
                                        'assets/images/alumni_placed.png',
                                        height: width / 10,
                                        width: width / 10,
                                      ),
                                    ),
                                    elevation: 20,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(
                                            width / 10)),
                                  ),
                                  SizedBox(height: 6.0),
                                  Container(
//                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      "Alumni Placed",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0xFF433d3e),
                                          fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                    ),
                                  ),
//                        Text(
//                          "Alumni Placed",
//                          style: TextStyle(
//                              fontFamily: 'Pacifico',
//                              fontSize: 15,
//                              fontWeight: FontWeight.bold,
//                              color: Colors.black26),
//                        ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                              onTap: () {
                                Navigator.pushNamed(context,ALUMNI_PLACED_SCREEN);
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            8.0, 12.0, 8.0, 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              child: Column(
                                children: <Widget>[
                                  Card(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: width / 10,
                                      child: Image.asset(
                                        'assets/images/seek_guidance.png',
                                        height: width / 10,
                                        width: width / 10,
                                      ),
                                    ),
                                    elevation: 20,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(
                                            width / 10)),
                                  ),
                                  SizedBox(height: 6.0),
                                  Container(
//                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      "Seek Guidance",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0xFF433d3e),
                                          fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                    ),
                                  ),
//                        Text(
//                          "Seek Guidance",
//                          style: TextStyle(
//                              fontFamily: 'Pacifico',
//                              fontSize: 15,
//                              fontWeight: FontWeight.bold,
//                              color: Colors.black26),
//                        ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                              onTap: () {
//                                Navigator.pushNamed(context,SOCIAL_BUSINESS);
                              },
                            ),
                            GestureDetector(
                              child: Column(
                                children: <Widget>[
                                  Card(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: width / 10,
                                      child: Image.asset(
                                        'assets/images/market_survey.png',
                                        height: width / 10,
                                        width: width / 10,
                                      ),
                                    ),
                                    elevation: 20,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(
                                            width / 10)),
                                  ),
                                  SizedBox(height: 6.0),
                                  Container(
//                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      "Market Survey",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0xFF433d3e),
                                          fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                    ),
                                  ),
//                        Text(
//                          "Market Survey",
//                          style: TextStyle(
//                              fontFamily: 'Pacifico',
//                              fontSize: 15,
//                              fontWeight: FontWeight.bold,
//                              color: Colors.black26),
//                        ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                              onTap: () {
                                Navigator.pushNamed(context,MARKET_SURVEY);
                              },
                            ),
                            GestureDetector(
                              child: Column(
                                children: <Widget>[
                                  Card(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: width / 10,
                                      child: Image.asset(
                                        'assets/images/write_to_admin.png',
                                        height: width / 10,
                                        width: width / 10,
                                      ),
                                    ),
                                    elevation: 20,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(
                                            width / 10)),
                                  ),
                                  SizedBox(height: 6.0),
                                  Container(
//                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      "Write to Admin",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0xFF433d3e),
                                          fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                    ),
                                  ),
//                        Text(
//                          "Write to Admin",
//                          style: TextStyle(
//                              fontFamily: 'Pacifico',
//                              fontSize: 15,
//                              fontWeight: FontWeight.bold,
//                              color: Colors.black26),
//                        ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                              onTap: () {
                                Navigator.pushNamed(context,WRITE_TO_ADMIN);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
