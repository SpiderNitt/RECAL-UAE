import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:iosrecal/constants/UIUtility.dart';
import 'package:iosrecal/constants/Api.dart';
import 'package:iosrecal/models/EventInfo.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/EventCard.dart';
import 'package:http/http.dart' as http;

class CompletedEvents extends StatefulWidget {
  List<EventInfo> list;
  int status;
  CompletedEvents(this.list,this.status);
  @override
  _CompletedEventsState createState() => _CompletedEventsState(list);
}

class _CompletedEventsState extends State<CompletedEvents> with TickerProviderStateMixin  {
  List<EventInfo> eventList;
  _CompletedEventsState(this.eventList);
  GlobalKey<AnimatedListState> animatedListKey=GlobalKey<AnimatedListState>();
  AnimationController emptyController;
  bool isEmpty=false;
  List<int> attended = new List<int>();
  bool finished=false;
  @override
  void initState() {
    super.initState();
    emptyController=AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    emptyController.forward();
    attended = List<int>.generate(eventList.length, (index) => index);
    asyncFor();
  }
  Widget EmptyList(BuildContext context){
    return Center(
      child: Text("No events to show",style: GoogleFonts.josefinSans(fontSize: 22,color: ColorGlobal.textColor),),
    );
  }
  Future updateList(index) async {
    var uri=Uri.parse(Api.getAttendees);
    uri = uri.replace(query: "id="+eventList[index].event_id.toString());
    SharedPreferences prefs=await SharedPreferences.getInstance();
    String user_id = prefs.getString('user_id');
    var response=await http.get(
        uri,
        headers: {
          "Accept" : "application/json",
          "Cookie" : "${prefs.getString("cookie")}",
        }
    ) .then((_response) {
      ResponseBody responseBody = new ResponseBody();
//      print('Response body:for attendees ${_response.body}'+ 'userid: $user_id');
      if (_response.statusCode == 200) {
        responseBody = ResponseBody.fromJson(json.decode(_response.body));
        if (responseBody.status_code == 200) {
//            print("STRIING: " + responseBody.data.toString());
            if(responseBody.data.toString() == "[]")
              attended.insert(index, 2);
            else {
              if (responseBody.data.toString().contains(
                  "attendee_id: $user_id")) {
                attended.insert(index, 1);
              }
              else
                attended.insert(index, 0);
            }
        } else {
          attended.insert(index, 2);
          print(responseBody.data);
        }
      } else {
        print('Server error');
        attended.insert(index, 2);
      }
    }).catchError((error) {
      print('Server error');
      attended.insert(index, 2);
    });
  }
//  void asyncForEach()  {
//    attended.forEach((index) async {
//      await updateList(index).then((value) {
//        print(attended.elementAt(index));
//        if(index==eventList.length-1)
//          setState(() {
//            finished=true;
//          });
//      });
//    });
//  }

//  Future asyncFor() async {
//    var map = {'a':1, 'b':2};
//    for (var mapEntry in map.entries) {
//      await update(map, mapEntry.key, mapEntry.value);
//    }
//    print(map);
//  }
  asyncFor() async {
    var index=0;
    while(index < eventList.length) {
      await updateList(index).then((value) {
        print("event att $index : ${attended.elementAt(index)}");
      });
      index++;
    }
    print("loop over");
    setState(() {
      finished=true;
    });
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    UIUtility().updateScreenDimesion(
        width: screenSize.width, height: screenSize.height);
    final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return eventList.isEmpty? EmptyList(context): finished==true ? Container(
      child: AnimatedList(
          key: animatedListKey,
          initialItemCount: eventList.length,
          itemBuilder: (BuildContext context, int index,animation) {
            return SizeTransition(child: VolunteerCard(eventList[index],true,widget.status,attended.elementAt(index)),
              sizeFactor: animation,);
          }
      ),

    ) : Center(child: SpinKitDoubleBounce(
      color:ColorGlobal.blueColor,
    ));
  }
}
