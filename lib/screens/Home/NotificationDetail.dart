import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/Constant/Constant.dart';
import 'package:iosrecal/models/NotificationDetailModel.dart';
import 'package:iosrecal/models/NotificationsModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/screens/Home/Arguments.dart';
import 'package:iosrecal/screens/Home/NoInternet.dart';
import 'package:iosrecal/screens/Home/errorWrong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:iosrecal/Endpoint/Api.dart';
import 'package:connectivity/connectivity.dart';

class NotificationDetail extends StatefulWidget {
  final NotificationsModel notificationsModel;
  NotificationDetail(this.notificationsModel);
  @override
  _NotificationDetailState createState() => _NotificationDetailState(notificationsModel);
}

class _NotificationDetailState extends State<NotificationDetail> {
  final NotificationsModel notificationsModel;
  _NotificationDetailState(this.notificationsModel);
  bool _hasError = false;
  bool _hasInternet = true;

  var notification = new NotificationDetailModel();
  int state = 0;
  initState() {
    super.initState();
    _notification();
  }

  Future<String> _notification() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _hasInternet=false;
      });

    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String URL = Api.getNotification + notificationsModel.notification_id.toString() + '&user_id=' + "${prefs.getString("user_id")}";
    print(URL);
    var response = await http.get(
        URL,
        headers: {
          "Accept": "application/json",
          "Cookie": "${prefs.getString("cookie")}",
        }
    );
    ResponseBody responseBody = new ResponseBody();

    if (response.statusCode == 200) {
      print("success");
//        updateCookie(_response);
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      if (responseBody.status_code == 200) {
        print("in here");
        notification = NotificationDetailModel.fromJson(responseBody.data);
        setState(() {
          state = 1;
        });
      } else if(responseBody.status_code==401){
        onTimeOut();
      }else {
        print("set error");
        setState(() {
          _hasError =  true;
        });
      }
    } else {
      print("set error");
      setState(() {
        _hasError =  true;
      });
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

  Widget _notificationText(){
    if(state==1){
      return Text(notification.body,
        style: TextStyle(
          fontSize: 20.0,
          fontStyle: FontStyle.italic,
        ),
      );
    }else{
      return Center(
        child:
        SpinKitDoubleBounce(
          color: Colors
              .lightBlueAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorGlobal.whiteColor,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: ColorGlobal.textColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              }
          ),
          title: Text(
            'Notifications',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: !_hasError ? !_hasInternet ? Center(child: NoInternetScreen()) :
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Material(
                color: Colors.white,
                elevation: 14.0,
                shadowColor: Color(0x802196F3),
                borderRadius: BorderRadius.circular(24.0),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: "Notification_" + notificationsModel.notification_id.toString(),
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(notificationsModel.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 24.0,
                      ),
                      _notificationText(),
                    ],
                  ),
                ),
              ),
              Image(
                fit: BoxFit.fitWidth,
                image: AssetImage('assets/images/notification_bg.png'),
                //alignment: Alignment.bottomCenter,
              )
            ],
          ) : Error8Screen(),
        ),
      ),
    );
  }
}


