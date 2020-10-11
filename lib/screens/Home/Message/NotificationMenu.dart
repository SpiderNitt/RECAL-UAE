import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/routes.dart';
import 'package:iosrecal/widgets/NoInternet.dart';
import 'package:iosrecal/screens/Home/Message/pages/NotificationDetail.dart';
import 'package:iosrecal/widgets/Error.dart';
import 'package:iosrecal/models/NotificationsModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/constants/Api.dart';
import 'package:iosrecal/widgets/NoData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:connectivity/connectivity.dart';
import 'package:iosrecal/constants/UIUtility.dart';

class NotificationsMenu extends StatefulWidget {
  @override
  _NotificationsMenuState createState() => _NotificationsMenuState();
}

class _NotificationsMenuState extends State<NotificationsMenu> {
  var notifications = new List<NotificationsModel>();
  var block_notification = new Map<String, List<NotificationsModel>>();
  int flag = 0;
  bool _hasMore = true;
  bool _hasError = false;
  bool _noData = false;
  bool _hasInternet = true;
  int page = 1;
  int error = 0;
  UIUtility uiUtills = new UIUtility();

  initState() {
    super.initState();
    _notifications();
    _hasMore = true;
    flag = 0;
    uiUtills = new UIUtility();
    print(block_notification.keys.toList().length);
  }

  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }

  int Comparison(NotificationsModel a, NotificationsModel b) {
    return b.created_at.compareTo(a.created_at);
  }

  refresh () {
    setState(() {
      _hasInternet=true;
      _hasError = false;
      _noData = false;
      _notifications();
      _hasMore = true;
      flag = 0;
    });
  }
  Future<String> _notifications() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _hasInternet=false;
        flag = 1;
        print("set flas");
      });
    }
    notifications = new List<NotificationsModel>();
    if (block_notification.length == 0) {
      block_notification = new Map<String, List<NotificationsModel>>();
    }
    flag = 0;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String URL = Api.getAllNotifications +
        "${prefs.getString("user_id")}" +
        '&page=' +
        "$page";
    print(URL);
    var response = await http.get(URL, headers: {
      "Accept": "application/json",
      "Cookie": "${prefs.getString("cookie")}",
    });
    ResponseBody responseBody = new ResponseBody();

    if (response.statusCode == 200) {
      print("got response");
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      print(responseBody.data);
      if (responseBody.status_code == 200) {
        setState(() {
          List list = responseBody.data["notifications"];
          notifications =
              list.map((model) => NotificationsModel.fromJson(model)).toList();
          notifications.sort(Comparison);

          notifications.forEach((element) {
            print("${element.title} ${element.created_at}");
            if (block_notification[element.created_at] == null) {
              block_notification[element.created_at] =
              new List<NotificationsModel>();
            }
            block_notification[element.created_at].add(element);
            print("length is : ");
            print(block_notification.keys.toList().length);

            for (var i = 0; i < block_notification.keys.toList().length; i++)
              print(block_notification.keys.toList().elementAt(i) +
                  "  ${block_notification[(block_notification.keys.toList()).elementAt(i)].length}");
            print("dates: ${block_notification.keys.toList().length}");
          });

          setState(() {
            if (page == 1 && notifications.length == 0) {
              setState(() {
                _noData = true;
              });
            }
            if (notifications.length < 15) {
              _hasMore = false;
            } else {
              page++;
              print("page updated");
            }
            flag = 1;
          });
        });
      } else if(responseBody.status_code==401){
        onTimeOut();
      }else {
        setState(() {
          _hasError = true;
        });
      }
    } else {
      setState(() {
        _hasError = true;
      });
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

  navigateAndReload(){
    Navigator.pushNamed(context, LOGIN_SCREEN, arguments: true)
        .then((value) {
      Navigator.pop(context);
      setState(() {

      });
      _notifications();
    });
  }

  Widget getBody() {
    print("get body");
    if(!_hasInternet){
      return Center(child: NoInternetScreen(notifyParent: refresh,));
    }
    if (_hasError) {
      return Center(
        child: Error8Screen(),
      );
    } else if (_noData) {
      return Center(
        child: NodataScreen(),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: _hasMore
          ? block_notification.keys.toList().length + 1
          : block_notification.keys.toList().length,
      itemBuilder: (context, index1) {
        int total = _hasMore
            ? block_notification.keys.toList().length + 1
            : block_notification.keys.toList().length;
        print("total : $total");
        print("index1: $index1");
        if (index1 >= block_notification.keys.toList().length) {
          if (flag == 1) {
            _notifications();
          }
          return Center(
            child: Padding(
              padding: EdgeInsets.only(top: getHeight(10, 2)),
              child: SpinKitDoubleBounce(
                color: ColorGlobal.blueColor,
              ),
            ),
          );
        }
        List date = block_notification.keys.toList()[index1].split("-");
        return Padding(
          padding: EdgeInsets.only(top: getHeight(5, 2)),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getWidth(10, 2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${date[2]}-${date[1]}-${date[0]}",
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w300,
                        fontSize: getWidth(15, 2),
                      ),
                    ),
                  ],
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: block_notification[
                (block_notification.keys.toList()).elementAt(index1)]
                    .length,
                itemBuilder: (context, index) {
                  print("index: $index");
                  IconData icon;
                  Color color;
                  NotificationsModel notification = (block_notification[
                  (block_notification.keys.toList()[index1])])
                      .elementAt(index);
                  if (notification.is_read) {
                    icon = Icons.notifications;
                    color = Colors.white;
                  } else {
                    icon = Icons.notifications_active;
                    color = Color(0xcc26cb3c);
                  }
                  return InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                NotificationDetail(notification)))
                        .then((value) {
                      setState(() {
                        (block_notification[
                        (block_notification.keys.toList()[index1])])
                            .elementAt(index).is_read = true;
                      });
                    }),
                    child: ListTile(
                      leading: CircleAvatar(
                        //backgroundColor: Color(color),
                        child: Icon(
                          icon,
                          color: color,
                          size: getWidth(25, 2),
                        ),
                      ),
                      title: Hero(
                        tag: "Notification_" +
                            notification.notification_id.toString(),
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            notification.title,
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.w500,
                              fontSize: getWidth(18, 2),
                              color: notification.is_read == true
                                  ? Colors.black
                                  : Color(0xcc26cb3c),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(left: getWidth(10, 2)),
                    child: Divider(),
                  );
                },
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index1) {
        return Padding(
          padding: EdgeInsets.only(left: getWidth(10, 2)),
          child: Divider(color: ColorGlobal.textColor),
        );
      },
    );
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
          leading: IconButton(
              icon: Icon(
                Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                color: ColorGlobal.textColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'Notifications',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: (flag == 0 && _hasInternet && !_hasError)
            ? Center(child: CircularProgressIndicator())
            : getBody(),
      ),
    );
  }
}