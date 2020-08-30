import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/NotificationDetailModel.dart';
import 'package:iosrecal/models/NotificationsModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/models/PositionModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constant/ColorGlobal.dart';

class NotificationDetail extends StatefulWidget {
  final NotificationsModel notificationsModel;
  NotificationDetail(this.notificationsModel);
  @override
  _NotificationDetailState createState() => _NotificationDetailState(notificationsModel);
}

class _NotificationDetailState extends State<NotificationDetail> {
  final NotificationsModel notificationsModel;
  _NotificationDetailState(this.notificationsModel);

  var notification = new NotificationDetailModel();
  int state = 0;
  initState() {
    super.initState();
    _notification();
  }

  Future<String> _notification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String URL = 'https://delta.nitt.edu/recal-uae/api/notifications/get_notification?id=' + notificationsModel.notification_id.toString() + '&user_id=' + "${prefs.getString("user_id")}";
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
        setState(() {
          state = 1;
        });
      } else {
        print(responseBody.data);
      }
    } else {
      print('Server error');
    }
  }

  Widget _notificationText(){
    if(state==1){
      return Text('Your request to volunteer for this event has been approved',
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Colors.white,
                elevation: 14.0,
                shadowColor: Color(0x802196F3),
                borderRadius: BorderRadius.circular(24.0),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
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
                        height: 24.0,
                      ),
                      _notificationText(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


