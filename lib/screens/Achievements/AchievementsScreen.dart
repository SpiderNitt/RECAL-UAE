import 'dart:convert';
import 'dart:io' show Platform;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:iosrecal/Constant/Constant.dart';
import 'package:iosrecal/models/AchievementModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/screens/Home/NoInternet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AchievementsScreen extends StatefulWidget {
  @override
  _AchievementsScreenState createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  int _index = 0;
  bool _hasInternet = true;
  var achievements = new List<AchievementModel>();

  Future<List<AchievementModel>> _getAchievements() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _hasInternet = false;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http
        .get("https://delta.nitt.edu/recal-uae/api/achievements/", headers: {
      "Accept": "application/json",
      "Cookie": "${prefs.getString("cookie")}",
    });
    if (response.statusCode == 200) {
      ResponseBody responseBody =
      ResponseBody.fromJson(json.decode(response.body));
      if (responseBody.status_code == 200) {
        List list = responseBody.data;
        achievements = list.map((model) => AchievementModel.fromJson(model)).toList();

        print(achievements.length);
        return achievements;
      } else if(responseBody.status_code==401){
        onTimeOut();
      }else {
        print(responseBody.data);
      }
    } else {
      print(response.statusCode);
      print('Server error');
    }
  }

  Future<bool> onTimeOut(){
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('Session Timeout'),
        content : Text('Login in continue'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => navigateAndReload(),
            child: Text("OK"),
          ),
        ],
      ),
    ) ??
        false;
  }

  refresh(){
    setState(() {

    });
    _hasInternet = true;
    _getAchievements();
  }

  navigateAndReload(){
    Navigator.pushNamed(context, LOGIN_SCREEN, arguments: true)
        .then((value) {
      Navigator.pop(context);
      setState(() {

      });
      _hasInternet = true;
      _getAchievements();});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorGlobal.whiteColor,
          title: Text(
            'Achievements',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
          leading: IconButton(
            icon: Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios, color: ColorGlobal.textColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
          margin: EdgeInsets.symmetric(vertical: 20),
          child: FutureBuilder(
            future: _getAchievements(),
            builder: (BuildContext context, AsyncSnapshot projectSnap) {
              if (_hasInternet == false) {
                return Center(child: NoInternetScreen(notifyParent: refresh));
              }
              if (projectSnap.data == null) {
                return Center(
                  child: SpinKitDoubleBounce(
                    color: ColorGlobal.blueColor,
                  ),
                );
              } else {
                return Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  //color: Colors.blue,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: PageView.builder(
                    itemCount: achievements.length,
                    controller: PageController(viewportFraction: 0.7),
                    onPageChanged: (int index) =>
                        setState(() => _index = index),
                    itemBuilder: (context, i) {
                      print(achievements[i].file);
                      return Transform.scale(
                        scale: i == _index ? 0.95 : 0.85,
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.1)),
                                child: Container(
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.5,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.5,
                                  decoration: new BoxDecoration(
                                    color: ColorGlobal.colorPrimaryDark,
                                    image: new DecorationImage(
                                      image: NetworkImage("https://delta.nitt.edu/recal-uae" + achievements[i].file.toString()),
                                      fit: BoxFit.cover,
                                    ),
                                    border: Border.all(
                                        color: ColorGlobal.whiteColor,
                                        width: 2),
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.1)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Text(
                                  achievements[i].name,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 18,
                                    letterSpacing: 1,
                                    color: ColorGlobal.textColor.withOpacity(
                                        0.9),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),

                              Card(
                                elevation: 2,
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  color: ColorGlobal.textColor,
                                  padding: EdgeInsets.all(5),
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Center(
                                      child: Text(
                                        achievements[i].category,
                                        style: TextStyle(
                                            color: ColorGlobal.whiteColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 5,
                              ),
                              Container(
                                height: MediaQuery.of(context).size.width * 0.5,
                                child: SingleChildScrollView(
                                  child: Text(
                                    achievements[i].description,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 1,
                                color: ColorGlobal.textColor.withOpacity(0.6),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                            ],
                          ),)
                        ,
                      );
                    },
                  ),
                );
              }
            },
          ),
        )
    );
  }
}