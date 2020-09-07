import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

import 'package:http/http.dart' as http;
import 'package:iosrecal/models/ChapterModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'dart:convert';
import '../Home/NoData.dart';

class VisionMission extends StatefulWidget {
  @override
  _VisionMissionState createState() => _VisionMissionState();
}

class _VisionMissionState extends State<VisionMission> {
  final int _numPages = 2;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  String vision;
  String mission;

  initState() {
    super.initState();
    _chapter();
  }

  Future<ChapterModel> _chapter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http
        .get("https://delta.nitt.edu/recal-uae/api/chapter/", headers: {
      "Accept": "application/json",
      "Cookie": "${prefs.getString("cookie")}",
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonChapter = jsonDecode(response.body);
      return ChapterModel.fromJson(jsonChapter);
    } else {
      throw Exception('Failed to load data');
    }
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? ColorGlobal.blueColor : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return MaterialApp(
        home: SafeArea(
            child: Scaffold(
      appBar: AppBar(
        backgroundColor: ColorGlobal.whiteColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorGlobal.textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Vision and Mission',
          style: TextStyle(color: ColorGlobal.textColor),
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: height / 1.35,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: height / 32,
                            ),
                            Center(
                              child: FadeIn(
                                child: Text(
                                  "VISION",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                // Optional paramaters
                                duration: Duration(milliseconds: 2000),
                                curve: Curves.easeIn,
                              ),
                            ),
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/images/visionbg.jpg',
                                ),
                                height: height / 3,
                                fit: BoxFit.fill,
                                //width: width / 1.5,
                              ),
                            ),
                            SizedBox(height: 12.0),
                            FadeIn(
                              child: FutureBuilder<ChapterModel>(
                                future: _chapter(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data.vision != null) {
                                      return Center(
                                          child: Text(
                                        snapshot.data.vision,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: ColorGlobal.textColor,
                                        ),
                                        textAlign: TextAlign.center,
                                      ));
                                    } else {
                                      return Center(
                                          child: Text(
                                        "NO DATA AVAILABLE",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: const Color(0xff3AAFFA),
                                            fontWeight: FontWeight.bold),
                                      ));
                                    }
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child: Text(
                                            "Error loading data, Please try again"));
                                  }
                                  // By default, show a loading spinner.
                                  return CircularProgressIndicator();
                                },
                              ),
                              duration: Duration(milliseconds: 2000),
                              curve: Curves.easeIn,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: height / 32,
                                ),
                                Center(
                                  child: FadeIn(
                                    child: Text(
                                      "MISSION",
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    // Optional paramaters
                                    duration: Duration(milliseconds: 2000),
                                    curve: Curves.easeIn,
                                  ),
                                ),
                                SizedBox(
                                  height: height / 40,
                                ),
                                Center(
                                  child: Image(
                                    image: AssetImage(
                                      'assets/images/missionbg.jpg',
                                    ),
                                    height: height / 3.5,
                                    //width: width / 1.5,
                                  ),
                                ),
                                SizedBox(
                                  height: height / 40,
                                ),
                                FadeIn(
                                  child: FutureBuilder<ChapterModel>(
                                    future: _chapter(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data.vision != null) {
                                          return Center(
                                              child: Text(
                                            snapshot.data.mission,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: ColorGlobal.textColor,
                                            ),
                                            textAlign: TextAlign.center,
                                          ));
                                        } else {
                                          return Center(
                                              child: Text(
                                            "NO DATA AVAILABLE",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: const Color(0xff3AAFFA),
                                                fontWeight: FontWeight.bold),
                                          ));
                                        }
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                "Error loading data, Please try again"));
                                      }
                                      // By default, show a loading spinner.
                                      return CircularProgressIndicator();
                                    },
                                  ),
                                  // Optional paramaters
                                  duration: Duration(milliseconds: 2000),
                                  curve: Curves.easeIn,
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
              ],
            ),
          ),
        ),
      ),
    )));
  }
}
