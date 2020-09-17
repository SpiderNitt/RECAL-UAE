import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/Constant/Constant.dart';
import 'package:iosrecal/models/AchievementModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/screens/Home/Arguments.dart';
import 'package:iosrecal/screens/Home/NoData.dart';
import 'package:iosrecal/screens/Home/errorWrong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:connectivity/connectivity.dart';
import 'package:iosrecal/screens/Home/NoInternet.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AchievementsScreen extends StatefulWidget {
  @override
  _AchievementsScreenState createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  int _index = 0;
  int internet = 1;
  int state = 0;
  var achievements = new List<AchievementModel>();

  Future<List<AchievementModel>> _getAchievements() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      internet = 0;
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
        print(list);
        for (var group in list) {
          AchievementModel mentorGroupModel = AchievementModel(
              id: group["id"],
              name: group["name"],
              description: group["description"],
              category: group["category"]);
          achievements.add(mentorGroupModel);
        }
        state = 1;
        print(achievements.length);
        return achievements;
      }else if(responseBody.status_code==401){
        onTimeOut();
      } else {
        state = 2;
        print(responseBody.data);
      }
    } else {
      state = 2;
      print(response.statusCode);
      print('Server error');
    }
  }
  Future<bool> onTimeOut(){
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Session Timeout'),
        content: new Text('Login to continue'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () async {
              //await _logoutUser();
              Navigator.pushReplacementNamed(context, LOGIN_SCREEN, arguments: TimeoutArguments(true));

            },
            child: FlatButton(
              color: Colors.red,
              child: Text("OK"),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  Widget getBody(){
//    if(state == 0){
//      return Center(
//        child: SpinKitDoubleBounce(
//          color: Colors
//              .lightBlueAccent,
//        ),
//      );
//    }
//    if(internet == 0){
//      return Center(child: NoInternetScreen());
//    }
//    if(state == 2){
//      return Center(child: Error8Screen());
//    }if(state == 1){
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 20),
        child: FutureBuilder(
          future: _getAchievements(),
          builder: (BuildContext context, AsyncSnapshot projectSnap) {
            switch (projectSnap.connectionState) {
              case ConnectionState.none:
                return Center(child: NoInternetScreen());
              case ConnectionState.waiting:
              case ConnectionState.active:
                return Center(
                  child: SpinKitDoubleBounce(
                    color: Colors
                        .lightBlueAccent,
                  ),
                );
              case ConnectionState.done:
                print("done");
                if (projectSnap.hasError) {
                  return internet == 0
                      ? Center(child: NoInternetScreen())
                      : Center(child: Error8Screen());
                } else {
                  if (projectSnap.data.length == 0) {
                    return Center(child: NodataScreen());
                  } else {
                    return Center(
                      child: PageView.builder(
                        itemCount: projectSnap.data.length,
                        controller: PageController(viewportFraction: 0.7),
                        onPageChanged: (int index) =>
                            setState(() => _index = index),
                        itemBuilder: (context, i) {
                          return Transform.scale(
                            scale: i == _index ? 0.95 : 0.85,
                            child: Container(
                              color: Colors.transparent,
                              child: Container(
                                child: Column(
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
                                            image: new AssetImage(
                                                'assets/images/admin.jpeg'),
                                            fit: BoxFit.contain,
                                          ),
                                          border: Border.all(
                                              color: ColorGlobal.whiteColor,
                                              width: 2),
                                          borderRadius: new BorderRadius.all(
                                              Radius.circular(
                                                  MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width *
                                                      0.1)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: Text(
                                        projectSnap.data[i].name,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontSize: 18,
                                          letterSpacing: 1,
                                          color: ColorGlobal.textColor
                                              .withOpacity(0.9),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Card(
                                      elevation: 2,
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10)),
                                      child: Container(
                                        color: ColorGlobal.textColor,
                                        padding: EdgeInsets.all(5),
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Center(
                                            child: Text(
                                              projectSnap.data[i].category,
                                              style: TextStyle(
                                                  color: ColorGlobal.whiteColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Text(
                                          projectSnap.data[i].description,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 16,
                                            letterSpacing: 1,
                                            color:
                                            ColorGlobal.textColor.withOpacity(
                                                0.6),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
            }
            return Center(child: Text("Try Again!"));
          }
        ),
      );
    //}
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
      ),
      body: getBody(),
    );
  }
}
