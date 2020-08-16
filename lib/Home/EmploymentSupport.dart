import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../Constant/Constant.dart';
import '../Constant/ColorGlobal.dart';

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
      builder: (context) => new AlertDialog(
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: ColorGlobal.whiteColor,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: ColorGlobal.textColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              }
          ),
          title: Text(
            'Employee Support',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
            child: Card(
              borderOnForeground: true,
              elevation: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                "Upload CV",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFF433d3e),
                                    fontWeight: FontWeight.w600),
                                maxLines: 1,
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        onTap: () {
//                                Navigator.pushNamed(context,SOCIAL_BUSINESS);
                          //_resumeOptions();
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
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, OPEN_POSITIONS);
                        },
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        child: Column(
                          children: <Widget>[
                            Card(
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: width / 10,
                                child: Image.asset(
                                  'assets/images/linkedin.png',
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
                                "LinkedIn Profiles",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFF433d3e),
                                    fontWeight: FontWeight.w600),
                                maxLines: 1,
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, MEMBER_LINKEDIN);
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
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, MARKET_SURVEY);
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
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
                                  borderRadius:
                                  new BorderRadius.circular(width / 10)),
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
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, ALUMNI_PLACED_SCREEN);
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
                                  borderRadius:
                                  new BorderRadius.circular(width / 10)),
                            ),
                            SizedBox(height: 6.0),
                            Container(
//                                    alignment: Alignment.center,
                              child: AutoSizeText(
                                "Resume Writing",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFF433d3e),
                                    fontWeight: FontWeight.w600),
                                maxLines: 1,
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, WRITE_RESUME_SCREEN);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
