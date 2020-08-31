import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iosrecal/Events/Event.dart';
import 'package:iosrecal/models/EventInfo.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant/ColorGlobal.dart';
import 'CompletedEvents.dart';
import 'UpcomingEvents.dart';
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
  bool isLoading=true;
  @override
  Widget build(BuildContext context) {
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
        ),
        body: isLoading?
        SpinKitDoubleBounce(
          color:ColorGlobal.color2,
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
                          height: 2,
                        ),
                        Icon(Icons.timer,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Upcoming",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    ),
                    Tab(icon:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 2,
                        ),
                        Icon(Icons.check_circle),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Completed",
                            style: TextStyle(fontSize: 14,),
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

  @override
  void initState() {
    super.initState();
    getData();
  }
  void getData() async{
    //var params={'event_id':'1'};
    //var uri='delta.nitt.edu/recal-uae/events/social_media/params?event_id=1';
    var uri=Uri.https('delta.nitt.edu', '/recal-uae/api/events/all_events/');
    SharedPreferences prefs=await SharedPreferences.getInstance();
    var response=await http.get(
        uri,
        headers: {
          "Accept" : "application/json",
          "Cookie" : "${prefs.getString("cookie")}",
        }
    ) .then((_response) {
      List<EventInfo> eventinfo =[];
      ResponseBody responseBody = new ResponseBody();
      print('Response body: ${_response.body}');
      if (_response.statusCode == 200) {
        responseBody = ResponseBody.fromJson(json.decode(_response.body));
        if (responseBody.status_code == 200) {
          //eventinfo=EventInfo.fromJson(json.decode(responseBody.data));
          //return [eventinfo.name, 1];
          if(responseBody.data!=[]) {
            for (var u in responseBody.data) {
              EventInfo currInfo = EventInfo.fromJson(u);
              eventinfo.add(currInfo);
            }
            if(widget.status==1){checkTime(eventinfo);}else{
              checkSocial(eventinfo);
            }
            print("Eventlist length=" + eventinfo.length.toString());
          }
          setState(() {
            isLoading=false;
          });
        } else {
          print(responseBody.data);
          //return [responseBody.data, 0];
        }
      } else {
        print('Server error');
        //return ["Server Error", 0];
      }
    });
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
