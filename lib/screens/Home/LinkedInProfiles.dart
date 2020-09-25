import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iosrecal/Constant/Constant.dart';
import 'package:iosrecal/screens/Home/MarketSurvey.dart';
import 'package:iosrecal/screens/Home/errorWrong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:flip_card/flip_card.dart';
import 'NoData.dart';
import 'NoInternet.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:iosrecal/Endpoint/Api.dart';
import 'package:connectivity/connectivity.dart';
import 'package:iosrecal/Constant/utils.dart';

class LinkedinModel {
  final int id;
  final String user;
  final String linkedin;

  LinkedinModel({this.id, this.user, this.linkedin});

  factory LinkedinModel.fromJson(Map<String, dynamic> json) {
    return LinkedinModel(
      id: json['id'],
      user: json['user'],
      linkedin: json['linkedin'],
    );
  }
}

_launchLinked(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print("error linkedin web");
  }
}

class LinkedIn extends StatefulWidget {
  @override
  LinkedinState createState() => LinkedinState();
}

class LinkedinState extends State<LinkedIn> {
  var positions = new List<LinkedinModel>();
  var state = 0;
  int internet = 1;
  int error = 0;

  List<String> fullList;
  List<GlobalKey<FlipCardState>> cardKey;
  initState() {
    super.initState();
    _positions();
  }

  Future<String> _positions() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        internet = 0;
      });
      print(internet);
      print("HI in connectivity");
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(Api.linkedinProfile, headers: {
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
          positions =
              list.map((model) => LinkedinModel.fromJson(model)).toList();
          positions.removeWhere((element) =>
          element.linkedin == null || element.linkedin.trim() == "");
          fullList = positions.map((e) => e.user).toList();
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: positions.length,
          itemBuilder: (context, index) {
            final double width = MediaQuery.of(context).size.width;
            final double height = MediaQuery.of(context).size.height;
            final List<Color> colorArray = [
              Colors.blue,
              Colors.purple,
              Colors.blueGrey,
              Colors.deepOrange,
              Colors.redAccent
            ];
            print(width);
            print(height);
            return FlipCard(
                key: cardKey[index],
                front: Container(
                    height: height / 8,
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      child: Card(
                        //color: ColorGlobal.blueColor,
                        elevation: 5,
                        shadowColor: const Color(0x802196F3),
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: width / 18,
                              ),
                              CircleAvatar(
                                radius: width / 14,
                                backgroundColor:
                                colorArray.elementAt(Random().nextInt(4)),
                                child: Text(
                                  positions[index].user.toUpperCase()[0],
                                  style: TextStyle(
                                      fontSize: width / 14,
                                      color: ColorGlobal.whiteColor),
                                ),
                              ),
                              SizedBox(
                                width: width / 16,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // Container(
                                  //   width: width - width / 2.75,
                                  //   child: Align(
                                  //     alignment: Alignment.topRight,
                                  //     child: Icon(
                                  //       Icons.swap_horiz,
                                  //       color: ColorGlobal.blueColor,
                                  //     ),
                                  //   ),
                                  // ),
                                  Container(
                                    child: AutoSizeText(
                                      positions[index].user.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: UIUtills()
                                            .getProportionalHeight(
                                            height: 16, choice: 3),
                                        color: ColorGlobal.textColor,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              // SizedBox(
                              //     width: width -
                              //         width / 1.5 -
                              //         positions[index].user.length),

                              // Align(
                              //   alignment: Alignment.topRight,
                              //   child: Icon(
                              //     Icons.swap_horiz,
                              //     color: ColorGlobal.blueColor,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    )),
                back: Container(
                    height: height / 8,
                    child: Card(
                      //color: ColorGlobal.blueColor,
                      elevation: 5,
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
                                GestureDetector(
                                  onTap: () async {
                                    await _launchLinked(
                                        positions[index].linkedin);
                                    cardKey[index].currentState.toggleCard();
                                  },
                                  child: AutoSizeText(
                                    positions[index].linkedin,
                                    //"Link",
                                    style: TextStyle(
                                      fontSize: UIUtills()
                                          .getProportionalHeight(
                                          height: 12, choice: 3),
                                      color: ColorGlobal.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    maxLines: 2,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
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
          actions: [
            IconButton(
              onPressed: () =>
                  showSearch(context: context, delegate: Search(positions))
                      .then((value) {
                    setState(() {
                      state = 0;
                      _positions();
                    });
                  }),
              icon: Icon(
                Icons.search,
                color: ColorGlobal.textColor,
              ),
            )
          ],
          title: Text(
            'LinkedIn Profiles',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: getBody(),
      ),
    );
  }
}

class Search extends SearchDelegate {
  List<GlobalKey<FlipCardState>> cardKey;
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
//      IconButton(
//        icon: Icon(Icons.remove_circle,color: ColorGlobal.textColor,),
//        onPressed: () => query="",
//      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: IconButton(
        icon: Icon(Icons.close, color: ColorGlobal.textColor),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  String selectedResult = "";
  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          selectedResult,
          style: TextStyle(color: ColorGlobal.textColor),
        ),
      ),
    );
  }

  final List<LinkedinModel> listExample;
  Search(this.listExample);

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = new List<String>();
    List<LinkedinModel> modelSuggestionList = new List<LinkedinModel>();
    if (query.isEmpty) {
      suggestionList = listExample.map((e) => e.user).toList();
      modelSuggestionList = listExample.map((e) => e).toList();
    } else {
      suggestionList.addAll(listExample.map((e) => e.user).toList().where(
              (element) => element.toLowerCase().contains(query.toLowerCase())));
      modelSuggestionList.addAll(listExample.map((e) => e).toList().where(
              (element) =>
              element.user.toLowerCase().contains(query.toLowerCase())));
    }
    cardKey = List<GlobalKey<FlipCardState>>.generate(
        modelSuggestionList.length, (index) => new GlobalObjectKey(index));

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: modelSuggestionList.length,
          itemBuilder: (context, index) {
            final double width = MediaQuery.of(context).size.width;
            final double height = MediaQuery.of(context).size.height;
            final List<Color> colorArray = [
              Colors.blue,
              Colors.purple,
              Colors.blueGrey,
              Colors.deepOrange,
              Colors.redAccent
            ];
            return FlipCard(
                key: cardKey[index],
                front: Container(
                    height: height / 8,
                    alignment: Alignment.topRight,
                    child: Card(
                      //color: ColorGlobal.blueColor,
                      elevation: 5,
                      shadowColor: const Color(0x802196F3),
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: width / 18,
                            ),
                            CircleAvatar(
                              radius: width / 14,
                              backgroundColor:
                              colorArray.elementAt(Random().nextInt(4)),
                              child: Text(
                                modelSuggestionList[index]
                                    .user
                                    .toUpperCase()[0],
                                style: TextStyle(
                                    fontSize: width / 14,
                                    color: ColorGlobal.whiteColor),
                              ),
                            ),
                            SizedBox(
                              width: width / 16,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // Container(
                                //   width: width - width / 2.75,
                                //   child: Align(
                                //     alignment: Alignment.topRight,
                                //     child: Icon(
                                //       Icons.swap_horiz,
                                //       color: ColorGlobal.blueColor,
                                //     ),
                                //   ),
                                // ),
                                AutoSizeText(
                                  modelSuggestionList[index].user.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: UIUtills().getProportionalHeight(
                                        height: 16, choice: 3),
                                    color: ColorGlobal.textColor,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                            // SizedBox(
                            //     width: width -
                            //         width / 1.5 -
                            //         positions[index].user.length),

                            // Align(
                            //   alignment: Alignment.topRight,
                            //   child: Icon(
                            //     Icons.swap_horiz,
                            //     color: ColorGlobal.blueColor,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    )),
                back: Container(
                    height: height / 8,
                    child: Card(
                      //color: ColorGlobal.blueColor,
                      elevation: 5,
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
                                GestureDetector(
                                  onTap: () async {
                                    await _launchLinked(
                                        modelSuggestionList[index].linkedin);
                                    cardKey[index].currentState.toggleCard();
                                  },
                                  child: AutoSizeText(
                                    modelSuggestionList[index].linkedin,
                                    //"Link",
                                    style: TextStyle(
                                      fontSize: UIUtills()
                                          .getProportionalHeight(
                                          height: 12, choice: 3),
                                      color: ColorGlobal.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    maxLines: 2,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ),
            );
          },
        ),
      ),
    );
  }
}