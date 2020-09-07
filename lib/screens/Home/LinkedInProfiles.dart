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

_launchyoutube(url) async {
  //const url = 'https://www.youtube.com/channel/UCEPOEe5azp3FbUjvMwttPqw';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class LinkedIn extends StatefulWidget {
  @override
  LinkedinState createState() => LinkedinState();
}

class LinkedinState extends State<LinkedIn> {
  var positions = new List<LinkedinModel>();
  var state = 0;
  initState() {
    super.initState();
    _positions();
  }

  Future<String> _positions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        "https://delta.nitt.edu/recal-uae/api/employment/linked_profiles",
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
          positions =
              list.map((model) => LinkedinModel.fromJson(model)).toList();
          for (int i = 0; i < positions.length; i++) {
            if (positions[i].id != null) {
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: positions.length,
          itemBuilder: (context, index) {
            final double width = MediaQuery.of(context).size.width;
            final double height = MediaQuery.of(context).size.height;
            return FlipCard(
                front: Container(
                    height: height / 8,
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      child: Card(
                        //color: ColorGlobal.blueColor,
                        elevation: 20,
                        shadowColor: const Color(0x802196F3),
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: width / 18,
                              ),
                              Image(
                                height: height / 16,
                                width: width / 8,
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/images/linkedinIcon.png'),
                                //alignment: Alignment.bottomCenter,
                              ),
                              SizedBox(
                                width: width / 16,
                              ),
                              Column(
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
                                  SizedBox(
                                    height: height / 32,
                                  ),
                                  AutoSizeText(
                                    positions[index].user.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20.0,
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
                      ),
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
                                      positions[index].linkedin,
                                      //"Link",
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
                            {_launchyoutube(positions[index].linkedin)})));
          },
        ),
      ),
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
            'LinkedIn Profiles',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: getBody(),
      ),
    );
  }
}
