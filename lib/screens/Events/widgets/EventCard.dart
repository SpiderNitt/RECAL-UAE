import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iosrecal/constants/Api.dart';
import 'package:iosrecal/screens/Events/pages/Felicitations.dart';
import 'package:iosrecal/models/EventInfo.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/Event.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'dart:async';
import 'package:iosrecal/constants/UIUtility.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class VolunteerCard extends StatefulWidget {
  EventInfo currEvent;
  bool isCompleted;
  bool isAttended=false;
  bool isCheckAttended=false;
  int attended = 2;
  int status;
  VolunteerCard( this.currEvent,this.isCompleted,this.status, this.attended);

  @override
  _VolunteerCardState createState() => _VolunteerCardState();
}

class _VolunteerCardState extends State<VolunteerCard> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
//    checkAttended();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
//  @override
//  void didChangeAppLifecycleState(AppLifecycleState state) {
//    if(state == AppLifecycleState.resumed){
//      print("resumed");
//      checkAttended();
//    }
//    else if(state == AppLifecycleState.inactive){
//      print("inactive");
//    }
//    else if(state == AppLifecycleState.paused){
//      print("paused");
//    }
//    else if(state == AppLifecycleState.detached){
//      print("detached");
//    }
//  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    UIUtility().updateScreenDimesion(
        width: screenSize.width, height: screenSize.height);
    return Padding(
      padding: EdgeInsets.all(UIUtility()
          .getProportionalHeight(
          height: 8)),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIUtility()
              .getProportionalHeight(
              height: 15)),
        ),
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(top: UIUtility()
                .getProportionalHeight(
                height: 2), right: UIUtility()
                .getProportionalWidth(
                width: 4),bottom:UIUtility()
                .getProportionalHeight(
                height: 6)),
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
                            fontSize: UIUtility()
                                .getProportionalHeight(
                                height: 16)),
                      ): Text(
                        getDate(),
                        style: TextStyle(
                            fontSize: UIUtility()
                                .getProportionalHeight(
                                height: 16),
                            color: ColorGlobal.color2,
                            fontWeight: FontWeight.bold),
                      ),

                      margin: EdgeInsets.only(
                          left: UIUtility()
                              .getProportionalWidth(
                              width: 14), top: UIUtility()
                          .getProportionalHeight(
                          height: 6), right: UIUtility()
                          .getProportionalWidth(
                          width: 4), bottom: UIUtility()
                          .getProportionalHeight(
                          height: 2)),
                    ),
                    widget.isCompleted==true ?
                    Container(
                      margin: EdgeInsets.only(top: UIUtility()
                          .getProportionalHeight(
                          height: 6)),
                      child:getAttendWidget(),
                    ) : SizedBox(),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                Container(
                  margin: EdgeInsets.only(top: UIUtility()
                      .getProportionalHeight(
                      height: 4)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            margin:EdgeInsets.only(left: UIUtility()
                                .getProportionalWidth(
                                width: 10)),
                            child: Icon(
                              Icons.event_note,
                              size: UIUtility()
                                  .getProportionalWidth(
                                  width: 32),
                              color: Colors.green,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: UIUtility()
                                .getProportionalWidth(
                                width: 4)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
    width:UIUtility().getProportionalWidth(width: 200),
                                  child: Text(
                                    widget.status==2?(widget.currEvent.event_name!=null?widget.currEvent.event_name:" "):getDate(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: UIUtility()
                                            .getProportionalHeight(
                                            height: 16),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: UIUtility()
                                      .getProportionalHeight(
                                      height: 3)),
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
                      Container(child: IconButton(icon:Icon(Icons.chevron_right,size: UIUtility()
                          .getProportionalWidth(
                          width: 22),),onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder:(context)=>
                        widget.status==2?Felicitations(widget.currEvent.event_id):Event(widget.isCompleted,widget.currEvent)));
                      },),margin: EdgeInsets.only(right: UIUtility()
                          .getProportionalWidth(
                          width: 8)),),
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
  Widget getAttendWidget() {
    if(widget.attended!=2){
      if(widget.attended==1){
        return Icon(Icons.check_circle,color: Colors.green,size: UIUtility()
            .getProportionalWidth(
            width: 24),);
      }
      else {
        return Icon(Icons.cancel,color: Colors.red,size:UIUtility()
            .getProportionalWidth(
            width: 24),);
      }
    }
    else{
      return SizedBox();
    }
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