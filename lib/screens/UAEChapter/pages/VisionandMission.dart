import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/Api.dart';
import '../../../constants/ColorGlobal.dart';
import '../../../constants/UIUtility.dart';
import '../../../models/ChapterModel.dart';
import '../../../models/ResponseBody.dart';
import '../../../routes.dart';
import '../../../widgets/Error.dart';
import '../../../widgets/KeepAlive.dart';
import '../../../widgets/NoInternet.dart';

class VisionMission extends StatefulWidget {
  @override
  _VisionMissionState createState() => _VisionMissionState();
}

class _VisionMissionState extends State<VisionMission>
    with AutomaticKeepAliveClientMixin<VisionMission> {
  final int _numPages = 2;
  final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);
  int _currentPage = 0;
  String vision;
  String mission;
  var state = 0;
  int internet = 1;
  bool error = false;

  @override
  bool get wantKeepAlive => true;

  initState() {
    super.initState();
    _chapter();
  }

  Future<String> _chapter() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        internet = 0;
      });
      Fluttertoast.showToast(
        msg: "Please connect to internet",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16,
      );
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await http.get(Api.chapterVisionMission, headers: {
      "Accept": "application/json",
      "Cookie": "${prefs.getString("cookie")}",
    });
    ResponseBody responseBody = new ResponseBody();
    if (response.statusCode == 200) {
      print("success");
//        updateCookie(_response);
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      if (responseBody.status_code == 200) {
        ChapterModel chapterDetails = ChapterModel.fromJson(responseBody.data);
        print(chapterDetails);
        vision = chapterDetails.vision == null
            ? "No data available"
            : chapterDetails.vision;
        mission = chapterDetails.mission == null
            ? "No data available"
            : chapterDetails.mission;
        if (vision != "" && mission != "") {
          setState(() {
            state = 1;
            error = false;
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

  Widget getBody() {
    final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    if (state == 0) {
      return SpinKitDoubleBounce(
        color: ColorGlobal.blueColor,
      );
    } else if (state == 1 && error == false) {
      return Padding(
        padding: EdgeInsets.all(
            UIUtility().getProportionalHeight(height: 10, choice: 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Container(
              color: ColorGlobal.color6,
              child: Image.asset(
                'assets/images/vision.png',
                height: height / 2,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
                height:
                UIUtility().getProportionalHeight(height: 12, choice: 1)),
            Center(
              child: AutoSizeText(
                'VISION',
                style: TextStyle(
                    fontSize:
                    UIUtility().getProportionalWidth(width: 22, choice: 1),
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),
                maxLines: 50,
              ),
            ),
            SizedBox(
                height:
                UIUtility().getProportionalHeight(height: 12, choice: 1)),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
              child: FadeIn(
                  child: AutoSizeText(
                    '\" ' + vision + ' \"',
                    style: TextStyle(
                      fontSize:
                      UIUtility().getProportionalWidth(width: 18, choice: 1),
                      color: ColorGlobal.textColor,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 50,
                    textAlign: TextAlign.center,
                  )),
            )
          ],
        ),
      );
    } else if (state == 1 && error == true) {
      return Padding(
        padding: EdgeInsets.all(
            UIUtility().getProportionalHeight(height: 10, choice: 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Image.asset(
                'assets/images/mission.png',
                height: height / 2,
                fit: BoxFit.cover,
              ),
              //width: width / 1.5,
            ),
            SizedBox(
                height:
                UIUtility().getProportionalHeight(height: 12, choice: 1)),
            Center(
                child: FadeIn(
                    child: AutoSizeText(
                      "NO DATA AVAILABLE",
                      style: TextStyle(
                        fontSize:
                        UIUtility().getProportionalWidth(width: 20, choice: 1),
                        color: ColorGlobal.textColor,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 50,
                    )))
          ],
        ),
      );
    } else {
      return Error8Screen();
    }
  }

  Widget getBody1() {
    final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    if (state == 0) {
      return SpinKitDoubleBounce(
        color: ColorGlobal.blueColor,
      );
    } else if (state == 1 && error == false) {
      return Padding(
        padding: EdgeInsets.all(
            UIUtility().getProportionalHeight(height: 10, choice: 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Container(
              color: ColorGlobal.color6,
              child: Image.asset(
                'assets/images/mission.png',
                height: height / 2,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
                height:
                UIUtility().getProportionalHeight(height: 12, choice: 1)),
            Center(
              child: AutoSizeText(
                'MISSION',
                style: TextStyle(
                    fontSize:
                    UIUtility().getProportionalWidth(width: 22, choice: 1),
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),
                maxLines: 50,
              ),
            ),
            SizedBox(
                height:
                    UIUtility().getProportionalHeight(height: 12, choice: 1)),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
              child: FadeIn(
                  child: AutoSizeText(
                '\" ' + mission + ' \"',
                style: TextStyle(
              fontSize:
                  UIUtility().getProportionalWidth(width: 18, choice: 1),
              color: ColorGlobal.textColor,
                  fontStyle: FontStyle.italic,
                ),
                    maxLines: 50,
                    textAlign: TextAlign.center,
              )),
            )
          ],
        ),
      );
    } else if (state == 1 && error == true) {
      return Padding(
        padding: EdgeInsets.all(
            UIUtility().getProportionalHeight(height: 10, choice: 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Image.asset(
                'assets/images/mission.png',
                height: height / 2,
                fit: BoxFit.cover,
              ),
              //width: width / 1.5,
            ),
            SizedBox(
                height:
                    UIUtility().getProportionalHeight(height: 12, choice: 1)),
            Center(
                child: FadeIn(
                    child: AutoSizeText(
              "NO DATA AVAILABLE",
              style: TextStyle(
                fontSize:
                    UIUtility().getProportionalWidth(width: 20, choice: 1),
                color: ColorGlobal.textColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 50,
            )))
          ],
        ),
      );
    } else {
      return Error8Screen();
    }
  }

  List<Widget> _buildPageIndicator() {
    print("40 ${UIUtility().getProportionalHeight(height: 40, choice: 1)}");
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(
          horizontal: UIUtility().getProportionalWidth(width: 8, choice: 1)),
      height: UIUtility().getProportionalHeight(height: 8, choice: 1),
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
    UIUtility().updateScreenDimesion(width: width, height: height);
    print("${UIUtility().screenWidth} ${UIUtility().screenHeight}");
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
            'Vision and Mission',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: internet == 0
            ? NoInternetScreen(
                notifyParent: refresh,
              )
            : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    color: ColorGlobal.whiteColor,
                    height: height -
                        UIUtility()
                            .getProportionalHeight(height: 100, choice: 1),
                    child: PageView(
                      physics: ClampingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: <Widget>[
                        KeepAlivePage(child: getBody()),
                        KeepAlivePage(child: getBody1())
                      ],
                    ),
                  ),
                ],
              ),
            ),
        bottomNavigationBar: internet == 0
            ? SizedBox()
            : Container(
                height:
                    UIUtility().getProportionalHeight(height: 60, choice: 1),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
              ),
      ),
    );
  }
}
