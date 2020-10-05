import 'dart:convert';
import 'dart:io' show Platform;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:iosrecal/routes.dart';
import 'package:iosrecal/constants/UIUtility.dart';
import 'package:iosrecal/constants/Api.dart';
import 'package:iosrecal/models/AchievementModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/widgets/NoInternet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AchievementsScreen extends StatefulWidget {
  @override
  _AchievementsScreenState createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  int _index = 0;
  bool _hasInternet = true;
  var achievements = new List<AchievementModel>();
  UIUtility uiUtills = new UIUtility();


  Future<List<AchievementModel>> _getAchievements() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _hasInternet = false;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http
        .get(Api.getAchievements, headers: {
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

  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    uiUtills.updateScreenDimesion(width: width, height: height);

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
        body: FutureBuilder(
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
                height: height,
                width: width,
                //color: Colors.blue,
                margin: EdgeInsets.symmetric(vertical: getHeight(20, 1)),
                child: PageView.builder(
                  itemCount: achievements.length,
                  controller: PageController(viewportFraction: 0.65),
                  onPageChanged: (int index) =>
                      setState(() => _index = index),
                  itemBuilder: (context, i) {
                    print(achievements[i].file);
                    return Transform.scale(
                      scale: i == _index ? 0.95 : 0.9,
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      height * 0.06)),
                              child: Container(
                                height: height * 0.3,
                                width: height * 0.3,
                                decoration: new BoxDecoration(
                                  color: ColorGlobal.whiteColor,
                                  image: new DecorationImage(
                                    image: NetworkImage(Api.imageUrl + achievements[i].file.toString(), ),
                                    fit: BoxFit.cover,
                                  ),
                                  border: Border.all(
                                      color: ColorGlobal.textColor,
                                      width: 2),
                                  borderRadius: new BorderRadius.all(
                                      Radius.circular(height * 0.06)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: getHeight(10, 1),
                            ),
                            Container(
                              child: Text(
                                achievements[i].name,
                                style: TextStyle(
                                  fontSize: getWidth(20, 1),
                                  color: ColorGlobal.textColor.withOpacity(
                                      0.9),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: getHeight(10, 1)),
                            Card(
                              elevation: 2,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(getHeight(10, 1))),
                              child: Container(
                                color: ColorGlobal.textColor,
                                padding: EdgeInsets.all(getHeight(5, 1)),
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Center(
                                    child: Text(
                                      achievements[i].category,
                                      style: TextStyle(
                                          color: ColorGlobal.whiteColor,
                                          fontSize: getWidth(18, 1),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: getHeight(10, 1),
                            ),
                            Container(
                              height: height * 0.3,
                              child: SingleChildScrollView(
                                child: Text(
                                  achievements[i].description,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: getWidth(17, 1),
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
        )
    );
  }
}