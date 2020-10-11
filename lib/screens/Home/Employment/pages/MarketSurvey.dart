import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iosrecal/routes.dart';
import 'package:iosrecal/widgets/Error.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:flip_card/flip_card.dart';
import '../../../../widgets/NoData.dart';
import '../../../../widgets/NoInternet.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:iosrecal/constants/Api.dart';
import 'package:connectivity/connectivity.dart';
import 'package:iosrecal/constants/UIUtility.dart';
import 'dart:io';

int num = 0;

_launchMarket(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print("error market web");
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
  int internet = 1;
  int error = 0;
  List<GlobalKey<FlipCardState>> cardKey;
  UIUtility uiUtills = new UIUtility();
  @override
  void initState() {
    super.initState();
    _positions();
    uiUtills = new UIUtility();
  }

  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }

  Future<String> _positions() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      internet = 0;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(Api.marketSurvey, headers: {
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
          positions.removeWhere(
              (element) => element.link == null || element.link.trim() == "");
          for (int i = 0; i < positions.length; i++) {
            if (positions[i].survey_id != null) {
              num++;
            }
          }
          cardKey = List<GlobalKey<FlipCardState>>.generate(
              positions.length, (index) => new GlobalObjectKey(index));
          print("Answer");
          print(positions.length);
          state = 1;
        });
      } else if (responseBody.status_code == 401) {
        onTimeOut();
      } else {
        print(responseBody.data);
        error = 1;
      }
    } else {
      print('Server error');
      error = 1;
    }
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

  navigateAndReload() {
    Navigator.pushNamed(context, LOGIN_SCREEN, arguments: true).then((value) {
      Navigator.pop(context);
      setState(() {});
      _positions();
    });
  }

  refresh() {
    setState(() {
      state = 0;
      internet = 1;
      error = 0;
    });
    _positions();
  }

  Widget getBody() {
    if (internet == 0) {
      return NoInternetScreen(notifyParent: refresh);
    } else if (error == 1) {
      return Error8Screen();
    } else if (state == 0) {
      return SpinKitDoubleBounce(
        color: ColorGlobal.blueColor,
      );
    } else if (state == 1 && positions.length == 0) {
      return NodataScreen();
    }
    return ListView.builder(
      itemCount: positions.length,
      itemBuilder: (context, index) {
        final double width = MediaQuery.of(context).size.width;
        final double height = MediaQuery.of(context).size.height;
        uiUtills.updateScreenDimesion(width: width, height: height);
        return FlipCard(
            key: cardKey[index],
            front: Container(
                height: height / 7,
                child: GestureDetector(
                  child: Card(
                    //color: ColorGlobal.blueColor,
                    elevation: 5,
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
                                  fontSize: getWidth(18, 3),
                                  color: ColorGlobal.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // onTap: () => cardKey.currentState.toggleCard(),
                )),
            back: Container(
                height: height / 7,
                child: Card(
                  //color: ColorGlobal.blueColor,
                  elevation: 5,
                  margin: const EdgeInsets.all(8),
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        await _launchMarket(positions[index].link);
                        cardKey[index].currentState.toggleCard();
                      },
                      child: AutoSizeText(
                        positions[index].link,
                        style: TextStyle(
                          fontSize: getWidth(10, 3),
                          color: ColorGlobal.textColor,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String uri;

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    uiUtills.updateScreenDimesion(width: width, height: height);
    return SafeArea(
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
