import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant/ColorGlobal.dart';

import 'package:url_launcher/url_launcher.dart';

class MarketSurvey {
  final String survey_id;
  final String text;
  final String link;
  final String user;
  MarketSurvey({this.survey_id, this.text, this.link, this.user});
  factory MarketSurvey.fromJson(Map<String,dynamic> json) {
    return MarketSurvey(
        survey_id: json["survey_id"],
        text: json["text"],
        link: json["link"],
        user: json["user"]);
  }
}
_launchsurvey(String url) async {

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
Future<MarketSurvey> getSurveyDetails() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var response = await http.get(
      "https://delta.nitt.edu/recal-uae/api/employment/market_survey",
      headers: {
        "Accept" : "application/json",
        "Cookie" : "${prefs.getString("cookie")}",
      }
  );


  if (response.statusCode == 200) {
    Map<String,dynamic> jsonSurvey = jsonDecode(response.body);
    return MarketSurvey.fromJson(jsonSurvey);

  } else {
    throw Exception('Failed to load survey link');
  }
}

class SurveyScreen extends StatefulWidget {
  @override
  SurveyScreenState createState() => new SurveyScreenState();
}

class SurveyScreenState extends State<SurveyScreen> {
  Future<bool> _onBackPressed() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
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
            'Market Survey',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.fromLTRB(20.0, height / 7, 20, 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          FutureBuilder<MarketSurvey>(
                            future: getSurveyDetails(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if(snapshot.data.link!=null){

                                  return Text(snapshot.data.link);
                                }
                                else{
                                  return Text("NO DATA AVAILABLE",  style: TextStyle(
                                      fontSize: 25,
                                      color: const Color(0xff3AAFFA),
                                      fontWeight: FontWeight.bold),);
                                }
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }

                              // By default, show a loading spinner.
                              return CircularProgressIndicator();
                            },),
                          // Text(
                          //   "Your opinion matters!!",
                          //   style: TextStyle(
                          //       fontSize: 25,
                          //       color: const Color(0xff3AAFFA),
                          //       fontWeight: FontWeight.bold),
                          // ),
                          SizedBox(height: 20.0),
                          Text(
                            "Click the button to view the market survey.",
                            style: TextStyle(
                              fontSize: 15,
                              color: const Color(0xff3AAFFA),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20.0),
                          FutureBuilder<MarketSurvey>(
                            future: getSurveyDetails(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if(snapshot.data.link != null){

                                  return Container(
                                    width: width / 2,
                                    height: 40,
                                    child: RaisedButton(
                                      onPressed: () {_launchsurvey(snapshot.data.link);},
                                      color: const Color(0xff3AAFFA),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0)),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                  "Go to survey",
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              )),
                                          Container(
                                            child: Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                              size: 30.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                else{
                                  return Text("NO DATA AVAILABLE",  style: TextStyle(
                                      fontSize: 15,
                                      color: const Color(0xff3AAFFA),
                                      fontWeight: FontWeight.bold),);
                                }
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }

                              // By default, show a loading spinner.
                              return CircularProgressIndicator();
                            },),

                        ],
                      )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Image(
                      height: height / 2,
                      width: width,
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/MarketSurvey.jpg'),
                      alignment: Alignment.bottomCenter,
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
