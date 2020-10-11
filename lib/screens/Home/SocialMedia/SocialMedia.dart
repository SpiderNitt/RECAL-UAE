import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/routes.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/SocialMediaModel.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'dart:io';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:iosrecal/constants/Api.dart';
import '../../../widgets/Error.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:iosrecal/widgets/NoInternet.dart';
import 'package:iosrecal/constants/UIUtility.dart';
import 'package:iosrecal/models/ChapterModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocialMediaScreen extends StatefulWidget {
  @override
  SocialMediaScreenState createState() => new SocialMediaScreenState();
}

_launchfacebook(url) async {
  // const url = 'https://www.facebook.com/NITT.Official/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchtwitter(url) async {
  //const url = 'https://twitter.com/recaluae?lang=en';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchhome(url) async {
  // const url = 'https://alumni.nitt.edu/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchyoutube(url) async {
  // const url = 'https://www.youtube.com/channel/UCEPOEe5azp3FbUjvMwttPqw';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchlinkedin(url) async {
  //const url = 'https://www.linkedin.com/school/nittrichy/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class SocialMediaScreenState extends State<SocialMediaScreen> {
  var state = 0;
  int internet = 1;
  bool error = false;
  var links = new List<SocialMediaModel>();
  String twitter = "";
  String facebook = "";
  String instagram = "";
  String youtube = "";
  String linkedin = "";
  UIUtility uiUtills = new UIUtility();

  initState() {
    super.initState();
    _chapter();
    uiUtills = new UIUtility();
  }

  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }

  Future<String> _chapter() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        internet = 0;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("hey1");
    var response = await http.get(Api.chapterVisionMission, headers: {
      "Accept": "application/json",
      "Cookie": "${prefs.getString("cookie")}",
    });
    ResponseBody responseBody = new ResponseBody();
    print("hey2");
    if (response.statusCode == 200) {
      print("success");
//        updateCookie(_response);
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      if (responseBody.status_code == 200) {
        ChapterModel chapterDetails = ChapterModel.fromJson(responseBody.data);
        print(chapterDetails);
        List list = chapterDetails.social_media;
        links = list.map((model) => SocialMediaModel.fromJson(model)).toList();
        print(links);
        if (links != null) {
          setState(() {
            state = 1;
            error = false;
            for (int i = 0; i < links.length; i++) {
              if (links[i].platform.toLowerCase().contains("tw")) {
                twitter = links[i].feed_url;
              } else if (links[i].platform.toLowerCase().contains("face")) {
                facebook = links[i].feed_url;
              } else if (links[i].platform.toLowerCase().contains("link")) {
                linkedin = links[i].feed_url;
              } else if (links[i].platform.toLowerCase().contains("insta")) {
                instagram = links[i].feed_url;
              } else if (links[i].platform.toLowerCase().contains("you")) {
                youtube = links[i].feed_url;
              }
            }
            print(twitter);
            print(instagram);
            print(facebook);
          });
        } else {
          setState(() {
            state = 1;
            error = true;
          });
        }
      } else if (responseBody.status_code == 401) {
        onTimeOut();
      } else {
        setState(() {
          state = 2;
        });
      }
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
      _chapter();
    });
  }

  refresh() {
    setState(() {
      state = 0;
      internet = 1;
      error = false;
    });
    _chapter();
  }

  @override
  Widget build(BuildContext context) {
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
          'Social Media',
          style: TextStyle(color: ColorGlobal.textColor),
        ),
      ),
      body: (internet == 0)
          ? NoInternetScreen(
              notifyParent: refresh(),
            )
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/SocialMedia.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: getHeight(20, 3)),
                          Container(
                            height: height / 8,
                            alignment: Alignment.center,
                            child: RaisedButton(
                              onPressed: () async {
                                await _launchfacebook(facebook);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff475993),
                                        Color(0xff2F5795)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: width / 3,
                                      minHeight: height / 6),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12.0, 0.0, 12.0, 0.0),
                                    child: Card(
                                      elevation: 20,
                                      color: Colors.white,
                                      child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            child: Image(
                                              height: 40.0,
                                              width: 40.0,
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  'assets/images/facebook.png'),
                                              alignment: Alignment.center,
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: getHeight(20, 3)),
                          Container(
                            height: height / 8,
                            alignment: Alignment.center,
                            child: RaisedButton(
                              onPressed: () async {
                                await _launchtwitter(twitter);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff76A9EA),
                                        Color(0xff03A9F4)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: width / 3,
                                      minHeight: height / 6),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12.0, 0.0, 12.0, 0.0),
                                    child: Card(
                                      elevation: 20,
                                      color: Colors.white,
                                      child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            child: Image(
                                              height: 40.0,
                                              width: 40.0,
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  'assets/images/twitter.png'),
                                              alignment: Alignment.center,
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: getHeight(20, 3)),
                          Container(
                            height: height / 8,
                            alignment: Alignment.center,
                            child: RaisedButton(
                              onPressed: () async {
                                await _launchyoutube(youtube);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xffE13D38),
                                        Color(0xffF44336)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: width / 3,
                                      minHeight: height / 6),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12.0, 0.0, 12.0, 0.0),
                                    child: Card(
                                      elevation: 20,
                                      color: Colors.white,
                                      child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            child: Image(
                                              height: 40.0,
                                              width: 40.0,
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  'assets/images/youtube.png'),
                                              alignment: Alignment.center,
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: getHeight(20, 3)),
                          Container(
                            height: height / 8,
                            alignment: Alignment.center,
                            child: RaisedButton(
                              onPressed: () async {
                                await _launchlinkedin(linkedin);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff2D959E),
                                        Color(0xff0084B1)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: width / 3,
                                      minHeight: height / 6),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12.0, 0.0, 12.0, 0.0),
                                    child: Card(
                                      elevation: 20,
                                      color: Colors.white,
                                      child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            child: Image(
                                              height: 40.0,
                                              width: 40.0,
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  'assets/images/linkedin.png'),
                                              alignment: Alignment.center,
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: getHeight(20, 3)),
                          Container(
                            height: height / 8,
                            alignment: Alignment.center,
                            child: RaisedButton(
                              onPressed: () async {
                                await _launchhome(instagram);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff00B1E8),
                                        Color(0xff00ECD1)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: width / 3,
                                      minHeight: height / 6),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12.0, 0.0, 12.0, 0.0),
                                    child: Card(
                                      elevation: 20,
                                      color: Colors.white,
                                      child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            child: Image(
                                              height: 40.0,
                                              width: 40.0,
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  'assets/images/instagram.png'),
                                              alignment: Alignment.center,
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: getHeight(20, 3)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    ));
  }
}
