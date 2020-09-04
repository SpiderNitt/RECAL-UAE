import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iosrecal/Events/Felicitations.dart';
import 'package:iosrecal/models/EventInfo.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './Event.dart';
import '../Constant/ColorGlobal.dart';
import '../Constant/ColorGlobal.dart';
import 'dart:async';
import '../Constant/utils.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class VolunteerCard extends StatefulWidget {
  EventInfo currEvent;
  bool isCompleted;
  bool isAttended=false;
  bool isCheckAttended=false;
  int status;
  VolunteerCard( this.currEvent,this.isCompleted,this.status);

  @override
  _VolunteerCardState createState() => _VolunteerCardState();
}

class _VolunteerCardState extends State<VolunteerCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAttended();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    UIUtills().updateScreenDimesion(
        width: screenSize.width, height: screenSize.height);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(top: 2, right: 4,bottom:6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      child:
                      widget.status!=2?Text( widget.currEvent.event_type!=null?(widget.currEvent.event_type):" ",
                        maxLines: 1,
                        style: TextStyle(
                            color: ColorGlobal.color2,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ): Text(
                        getDate(),
                        style: TextStyle(
                            fontSize: 16,
                            color: ColorGlobal.color2,
                            fontWeight: FontWeight.bold),
                      ),

                      margin: EdgeInsets.only(
                          left: 14, top: 6, right: 4, bottom: 2),
                    ),
                    widget.isCompleted==true ?
                    Container(
                      margin: EdgeInsets.only(top: 6),
                      child:getAttendWidget(),
                    ) : SizedBox(),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            margin:EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.event_note,
                              size: 32,
                              color: Colors.green,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
    width:UIUtills().getProportionalWidth(width: 200),
                                  child: Text(
                                    widget.status==2?(widget.currEvent.event_name!=null?widget.currEvent.event_name:" "):getDate(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 3),
                                  child: Text(
                                    getTime(),
                                    style: TextStyle(
                                      color: Colors.black45,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(child: IconButton(icon:Icon(Icons.chevron_right),onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder:(context)=>
                        widget.status==2?Felicitations(widget.currEvent.event_id):Event(widget.isCompleted,widget.currEvent)));
                      },),margin: EdgeInsets.only(right: 8),),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget getAttendWidget(){
    if(widget.isCheckAttended){
      if(widget.isAttended){
        return Icon(Icons.check_circle,color: Colors.green,);
      }
      else {
        return Icon(Icons.cancel,color: Colors.red,);
      }
    }
    else{
      return SizedBox();
    }
  }
  Future<void> checkAttended() async{
    var params={'id':widget.currEvent.event_id.toString()};
    var uri=Uri.https('delta.nitt.edu', '/recal-uae/api/event/attendees/',params);
    SharedPreferences prefs=await SharedPreferences.getInstance();
    var response=await http.get(
        uri,
        headers: {
          "Accept" : "application/json",
          "Cookie" : "${prefs.getString("cookie")}",
        }
    ) .then((_response) {
      ResponseBody responseBody = new ResponseBody();
      print('Response body:for attendees ${_response.body}'+ 'userid: ${prefs.getString('user_id')}');
      if (_response.statusCode == 200) {
        responseBody = ResponseBody.fromJson(json.decode(_response.body));
        if (responseBody.status_code == 200) {
          if(responseBody.data.length!=0) {
            for (var u in responseBody.data) {
              if(u['attendee_id'].toString()== prefs.getString('user_id')){
                setState(() {
                  widget.isAttended=true;
                });

              }
            }
            setState(() {
              widget.isCheckAttended=true;
            });
          }
        } else {
          print(responseBody.data);
        }
      } else {
        print('Server error');
      }
    });

  }
  String getDate(){
    var date=DateTime.parse(widget.currEvent.datetime);
    var updateddate=DateFormat.yMMMMd().format(date);
    return updateddate;
  }
  String getTime(){
    var date=DateTime.parse(widget.currEvent.datetime);
    var updateddate=DateFormat.jm().format(date);
    return updateddate;
  }

}