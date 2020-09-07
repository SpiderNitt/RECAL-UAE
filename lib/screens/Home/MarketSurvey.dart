import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:flip_card/flip_card.dart';
import 'NoData.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auto_size_text/auto_size_text.dart';

int num = 0;

_launchyoutube(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

class SurveyModel {
  final int survey_id;
  final String user;
  final String text;
  final String link;

  SurveyModel({
    this.survey_id,
    this.text,
    this.link,
    this.user,
  });

  factory SurveyModel.fromJson(Map<String, dynamic> json) {
    return SurveyModel(
      survey_id: json['survey_id'],
      text: json['text'],
      link: json['link'],
      user: json['user'],
    );
  }
}

class SurveyScreen extends StatefulWidget {
  @override
  SurveyState createState() => SurveyState();
}

class SurveyState extends State<SurveyScreen> {
  var positions = new List<SurveyModel>();
  var state = 0;
  @override
  void initState() {
    super.initState();
    _positions();
  }

  Future<String> _positions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        "https://delta.nitt.edu/recal-uae/api/employment/market_survey",
        headers: {
          "Accept": "application/json",
          "Cookie": "${prefs.getString("cookie")}",
        });
    ResponseBody responseBody = new ResponseBody();

    if (response.statusCode == 200) {
      print("success");
//        updateCookie(_response);
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      if (responseBody.status_code == 200) {
        setState(() {
          List list = responseBody.data;
          positions = list.map((model) => SurveyModel.fromJson(model)).toList();
          for (int i = 0; i < positions.length; i++) {
            if (positions[i].survey_id != null) {
              num++;
            }
          }
          print("Answer");
          print(positions.length);
          state = 1;
        });
      } else {
        print(responseBody.data);
      }
    } else {
      print('Server error');
    }
  }

  Widget getBody() {
    if (state == 0) {
      return SpinKitDoubleBounce(
        color: Colors.lightBlueAccent,
      );
    } else if (state == 1 && positions.length == 0) {
      return NodataScreen();
    }
    return ListView.builder(
      itemCount: positions.length,
      itemBuilder: (context, index) {
        final double width = MediaQuery.of(context).size.width;
        final double height = MediaQuery.of(context).size.height;
        return FlipCard(
          //key: cardKey,
          // flipOnTouch: false,
            front: Container(
                height: height / 8,
                child: GestureDetector(
                  child: Card(
                    //color: ColorGlobal.blueColor,
                    elevation: 20,
//                            shadowColor: const Color(0x802196F3),
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          // SizedBox(
                          //   width: width / 5,
                          // ),
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: width - width / 5,
                                  ),
                                  Icon(
                                    Icons.swap_horiz,
                                    color: ColorGlobal.blueColor,
                                  ),
                                ],
                              ),
                              // SizedBox(height: height / 42),
                              AutoSizeText(
                                positions[index].text.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: ColorGlobal.textColor,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.0),
                        ],
                      ),
                    ),
                  ),
                  // onTap: () => cardKey.currentState.toggleCard(),
                )),
            back: Container(
                height: height / 8,
                child: GestureDetector(
                    child: Card(
                      //color: ColorGlobal.blueColor,
                      elevation: 20,
//                              shadowColor: const Color(0x802196F3),
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                //SizedBox(height: height / 32),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: width - width / 5,
                                    ),
                                    Icon(
                                      Icons.swap_horiz,
                                      color: ColorGlobal.blueColor,
                                    ),
                                  ],
                                ),
                                AutoSizeText(
                                  positions[index].link,
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    color: ColorGlobal.textColor,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    onLongPress: () =>
                    {_launchyoutube(positions[index].link)})));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String uri;

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorGlobal.whiteColor,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: ColorGlobal.textColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'Market Survey',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: getBody(),
          ),
        ),
      ),
    );
  }
}