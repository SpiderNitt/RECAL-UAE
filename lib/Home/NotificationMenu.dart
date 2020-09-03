import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/Home/NotificationDetail.dart';
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
  var all_notifications = new List<NotificationsModel>();
  int page = 1;
  bool _isLoading = true;
  bool _hasMore = true;

  initState() {
    super.initState();
    _isLoading = true;
    _hasMore = true;
    _notifications();
  }

  Future<String> _notifications() async {
    //setState(() {
      _isLoading = true;
    //});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String URL = 'https://delta.nitt.edu/recal-uae/api/notifications/?id=' + "${prefs.getString("user_id")}" + '&page=' + page.toString();
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
        List list = responseBody.data;
        notifications =
            list.map((model) => NotificationsModel.fromJson(model)).toList();
        all_notifications.addAll(notifications);
        if (notifications.length<15) {
          setState(() {
            _isLoading = false;
            _hasMore = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            page++;
            print(page);
          });
        }
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
          child: ListView.builder(
            itemCount: _hasMore ? all_notifications.length + 1 : all_notifications.length,
            itemBuilder: (context, index) {
              print("index : " + index.toString());
              if (index >= all_notifications.length) {
                print("load more!");
                // Don't trigger if one async loading is already under way
                if (!_isLoading) {
                  _notifications();
                }
                return Center(
                  child:
                  SpinKitDoubleBounce(
                    color: Colors
                        .lightBlueAccent,
                  ),
                );
              }
              IconData icon;
              Color color;
              if(all_notifications[index].is_read){
                icon = Icons.notifications;
                color = Colors.white;
              }
              else{
                icon = Icons.notifications_active;
                color =Color(0xcc26cb3c);
              }
              return InkWell(
                onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationDetail(notifications[index]))),
                child: ListTile(
                  leading: CircleAvatar(
                    //backgroundColor: Color(color),
                    child: Icon(
                      icon,
                      color: ColorGlobal.whiteColor,
                    ),
                  ),
                  title: Hero(
                    tag: "Notification_" + all_notifications[index].notification_id.toString(),
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(all_notifications[index].title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20.0,
                        ),
                      ),
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
                ),
              );
            },
//            separatorBuilder: (context, index) {
//              return Padding(
//                padding: const EdgeInsets.only(left: 40.0),
//                child: Divider(),
//              );
//            },
          ),
        ),
      ),
    );
  }
}
