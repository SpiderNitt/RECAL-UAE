import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/NotificationsModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/models/PositionModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constant/ColorGlobal.dart';

class NotificationsMenu extends StatefulWidget {
  @override
  _NotificationsMenuState createState() => _NotificationsMenuState();
}

class _NotificationsMenuState extends State<NotificationsMenu> {

  var notifications = new List<NotificationsModel>();

  initState() {
    super.initState();
    _notifications();
  }

  Future<String> _notifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String URL = 'https://delta.nitt.edu/recal-uae/api/notifications/?id=' + "${prefs.getString("user_id")}" + '&page=1';
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
          List list = responseBody.data;
          notifications =
              list.map((model) => NotificationsModel.fromJson(model)).toList();
        });
      } else {
        print(responseBody.data);
      }
    } else {
      print('Server error');
    }
  }
  @override
  Widget build(BuildContext context) {
    String uri;
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
          child: ListView.separated(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              IconData icon;
              Color color;
              if(notifications[index].is_read){
                icon = Icons.notifications;
                color = Colors.white;
              }
              else{
                icon = Icons.notifications_active;
                color =Color(0xcc26cb3c);
              }
              return ListTile(
                leading: CircleAvatar(
                  //backgroundColor: Color(color),
                  child: Icon(
                    icon,
                    color: ColorGlobal.whiteColor,
                  ),
                ),
                title: Text(notifications[index].title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                  ),
                ),
                trailing: Container(
                  height: 10.0,
                  width: 10.0,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Divider(),
              );
            },
          ),
        ),
      ),
    );
  }
}
