import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/routes.dart';
import 'package:iosrecal/constants/UIUtility.dart';
import 'package:iosrecal/constants/Api.dart';
import 'package:iosrecal/screens/Events/pages/Event.dart';
import 'package:iosrecal/models/EventInfo.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/widgets/NoInternet.dart';
import 'package:iosrecal/widgets/Error.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'pages/CompletedEvents.dart';
import 'pages/UpcomingEvents.dart';
import 'dart:io' show Platform;
import 'pages/UpcomingEvents.dart';
import 'package:http/http.dart' as http;

class EventsScreen extends StatefulWidget {
  int status;
  EventsScreen(this.status);
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<EventInfo> upcomingEventsList=[];
  List<EventInfo> completedEventsList=[];
  List<EventInfo> socialEvents =[];
  double position=1;
  int internet = 1;
  bool isLoadingData=true;
  bool isServerError=false;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    UIUtility().updateScreenDimesion(
        width: screenSize.width, height: screenSize.height);
    return SafeArea (
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: ColorGlobal.textColor
          ),
          backgroundColor: ColorGlobal.whiteColor,
          title: Text(
            'Events',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
          leading: IconButton(
              icon: Icon(
                Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                color: ColorGlobal.textColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: isLoadingData?
        internet==0?Center(child: NoInternetScreen(notifyParent: refresh,)):isServerError?Error8Screen():
        SpinKitDoubleBounce(
          color:ColorGlobal.blueColor,
        )
            :widget.status==1?DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              Material(
                color: ColorGlobal.blueColor,
                child: TabBar(
                  indicatorColor: ColorGlobal.textColor,
                  indicatorWeight: 3,
                  unselectedLabelColor: ColorGlobal.whiteColor.withOpacity(0.5),
                  onTap: (index){
                    setState(() {
                      position = 0;
                    });
                  },
                  tabs:[
                    Tab(icon:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: UIUtility()
                              .getProportionalHeight(
                              height: 2),
                        ),
                        Icon(Icons.event,size: UIUtility()
                            .getProportionalWidth(
                            width: 24),),
                        Padding(
                          padding: EdgeInsets.all(UIUtility()
                              .getProportionalHeight(
                              height: 8)),
                          child: AutoSizeText(
                            "UPCOMING",
                            style: GoogleFonts.josefinSans(fontSize: UIUtility()
                                .getProportionalWidth(
                                width: 15), fontWeight: FontWeight.w700),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    ),
                    Tab(icon:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: UIUtility()
                              .getProportionalHeight(
                              height: 2),
                        ),
                        Icon(Icons.event_available,size: UIUtility()
                            .getProportionalWidth(
                            width: 24),),
                        Padding(
                          padding: EdgeInsets.all(UIUtility()
                              .getProportionalHeight(
                              height: 8)),
                          child: AutoSizeText(
                            "COMPLETED",
                            style: GoogleFonts.josefinSans(fontSize: UIUtility()
                                .getProportionalWidth(
                                width: 15), fontWeight: FontWeight.w700),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    UpcomingEvents(upcomingEventsList),
                    CompletedEvents(completedEventsList,1),
                  ],
                ),
              )
            ],
          ),
        ):CompletedEvents(socialEvents,2),
      ),
    );
  }
  refresh() {
    getData();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }
  void getData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        internet = 0;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await http.get(
        Api.getAllEvents,
        headers: {
          "Accept": "application/json",
          "Cookie": "${prefs.getString("cookie")}",
        }
    ).then((_response) {
      List<EventInfo> eventinfo = [];
      ResponseBody responseBody = new ResponseBody();
      print('Response body: ${_response.body}');
      if (_response.statusCode == 200) {
        responseBody = ResponseBody.fromJson(json.decode(_response.body));
        if (responseBody.status_code == 200) {
          if (responseBody.data != []) {
            for (var u in responseBody.data) {
              EventInfo currInfo = EventInfo.fromJson(u);
              eventinfo.add(currInfo);
            }
            if (widget.status == 1) {
              checkTime(eventinfo);
            } else {
              checkSocial(eventinfo);
            }
            print("Eventlist length=" + eventinfo.length.toString());
          }
          setState(() {
            isLoadingData = false;
          });
        } else if (responseBody.status_code == 401) {
          onTimeOut();
        } else {
          print(responseBody.data);
        }
      } else {
        print('Server error');
        setState(() {
          isServerError = true;
        });
      }
    });
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

  navigateAndReload(){
    Navigator.pushNamed(context, LOGIN_SCREEN, arguments: true)
        .then((value) {
      int param=widget.status;
      Navigator.pop(context);
      EventsScreen(param);
      getData();});

  }
  void checkSocial(List<EventInfo> eventinfo){
    for(var curr in eventinfo){
      if(curr.event_type=="Social"){
        socialEvents.add(curr);
      }
    }
  }
  void checkTime(List<EventInfo> eventinfo){
    var currDate=DateTime.now();
    for(var curr in eventinfo){
      DateTime eventdate = DateTime.parse(curr.datetime);
      if(currDate.isAfter(eventdate)){
        completedEventsList.add(curr);
      }else {
        upcomingEventsList.add(curr);
      }
    }
    print("Upcominglist="+upcomingEventsList.length.toString());
    print("CompletedList="+completedEventsList.length.toString());
  }
}
