import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/Constant/Constant.dart';
import 'package:iosrecal/models/AchievementModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/screens/Home/NoInternet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';

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
        print(list);
        for (var group in list) {
          AchievementModel mentorGroupModel = AchievementModel(
              id: group["id"],
              name: group["name"],
              description: group["description"],
              category: group["category"]);
          achievements.add(mentorGroupModel);
        }

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
        title: new Text('Session Timeout'),
        content: new Text('Login to continue'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () async {
              //await _logoutUser();
              navigateAndReload();
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
          icon: Icon(Icons.arrow_back, color: ColorGlobal.textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 20),
        child: FutureBuilder(
          future: _getAchievements(),
          builder: (BuildContext context, AsyncSnapshot projectSnap) {
            if(_hasInternet==false){
              return Center(child: NoInternetScreen(notifyParent: refresh));
            }
            if (projectSnap.data == null) {
              return Center(
                child: SpinKitDoubleBounce(
                  color: Colors.lightBlueAccent,
                ),
              );
            } else {
              return PageView.builder(
                itemCount: projectSnap.data.length,
                controller: PageController(viewportFraction: 0.4),
                onPageChanged: (int index) => setState(() => _index = index),
                itemBuilder: (context, i) {
                  return Transform.scale(
                    scale: i == _index ? 0.95 : 0.85,
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.width/8,
                          backgroundColor: Colors.blue,
                          child: Text(projectSnap.data[i].name.toUpperCase()[0],style: TextStyle(fontSize: MediaQuery.of(context).size.width/8, color: ColorGlobal.whiteColor),),
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
                              color: ColorGlobal.textColor.withOpacity(0.9),
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
                              borderRadius: BorderRadius.circular(10)),
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
                                ColorGlobal.textColor.withOpacity(0.6),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
          }
        },
      ),
    )
    );
  }
}