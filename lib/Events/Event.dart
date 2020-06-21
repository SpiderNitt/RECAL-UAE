import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iosrecal/Constant/utils.dart';
import 'package:iosrecal/models/EventInfo.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import '../models/socialmedia_feed.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import '../Constant/ColorGlobal.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
class Event extends StatefulWidget {
  bool isCompleted=false;
  EventInfo currEvent;
  Event(this.isCompleted,this.currEvent);
  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  final List<int> numbers = [1, 2, 3, 4, 5, 5, 2, 3, 5];
  @override
  Widget build(BuildContext context) {
    final screenSize=MediaQuery.of(context).size;
    UIUtills().updateScreenDimesion(width: screenSize.width,height: screenSize.height);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: -5,
          title: Text("Event Details",style: TextStyle(color: ColorGlobal.textColor)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorGlobal.textColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: ColorGlobal.whiteColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: ColorGlobal.blueColor.withOpacity(0.5),width: 2)
                ),
                child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: "https://picsum.photos/300",fit: BoxFit.fitWidth,),
                width: MediaQuery.of(context).size.width,
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          getDate(),
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                        Text(
                          getTime(),
                          style: TextStyle(color: Colors.blueGrey),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Icon(
                                Icons.place,
                                size: 36,
                                color: ColorGlobal.color2,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 4),
                              child: (widget.currEvent.location==null&&widget.currEvent.emirate_id==null)?Text(
                                "N/A",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ):Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  widget.currEvent.emirate_id==null?SizedBox(height: 6,):Text(
                                    getEmirate(),
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    width: UIUtills().getProportionalWidth(width: 300),
                                    margin: EdgeInsets.only(top: 3),
                                    child: widget.currEvent.location!=null?Text(
                                      widget.currEvent.location,
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      style: widget.currEvent.emirate_id!=null?TextStyle(
                                          color: Colors.black45, fontSize: 16):TextStyle(
                                          color: Colors.black54,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ):SizedBox(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(top: 6),
                            child: widget.currEvent.detail_message==null?SizedBox():Text(
                              widget.currEvent.detail_message,
                              style:
                              TextStyle(color: Colors.blueGrey, fontSize: 16),
                            )),
                        Container(
                            margin: EdgeInsets.only(top: 6),
                            child: widget.currEvent.detail_amendment_message==null?SizedBox():Text(
                              widget.currEvent.detail_amendment_message,
                              style:
                              TextStyle(color: Colors.blueGrey, fontSize: 16),
                            )),
                        widget.isCompleted?Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: numbers.length, itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Card(
                                //color: Colors.blue,
                                child: Container(
                                  child: Image.network("https://picsum.photos/300",fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext ctx, Widget child, ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }else {
                                        return Center(
                                          child: SpinKitDoubleBounce(
                                            color: Colors.lightBlueAccent,
                                          ),
                                        );
                                      }
                                    },       ),
                                ),
                              ),
                            );
                          }),
                        ):Column(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(top: 6),
                                child: Text(
                                  widget.currEvent.volunteer_message??" ",
                                  style:
                                  TextStyle(color: Colors.blueGrey, fontSize: 16),
                                )),
                            Container(margin: EdgeInsets.only(top:4),child: widget.currEvent.registration_link==null?SizedBox():InkWell(child: Text("Register Here",style: TextStyle(color: Colors.blue)),onTap: ()=>launch(widget.currEvent.registration_link),)),
                          ],
                        ),
                        widget.isCompleted?SizedBox(height: 0,width: 0,):SizedBox(height: 20,),
                        FutureBuilder(
                          future: getSocialMediaLinks(),
                          builder: (BuildContext context,AsyncSnapshot snapshot){
                            if(snapshot.data==null){
                              return Container(
                                child: SizedBox(),
                              );
                            }else{
                              return ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder:(BuildContext context,int index){
                                    return Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(color: ColorGlobal.blueColor.withOpacity(0.5),width: 2)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(snapshot.data[index].platform),
                                          Text(snapshot.data[index].feed_url,style: TextStyle(
                                              color: Colors.blue
                                          ),)
                                        ],
                                      ),
                                    );
                                  } );
                            }
                          },
                        ),

                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
  String getEmirate() {
    String id=widget.currEvent.emirate_id;
    String emirate;
    switch(id){
      case '1': emirate="Dubai";break;
      case '2': emirate="Abu Dhabi";break;
      case '3': emirate="Ajman";break;
      case '4': emirate="Fujairah";break;
      case '5': emirate="Ras Al Khaimah";break;
      case '6': emirate="Sharjah";break;
      case '7': emirate="Umm Al Quwain";break;
    }
    print(emirate);
    return emirate;
  }

//  Future<List<SponsorInfo>> getSponsorInfo()async{
//
//  }
  Future<List<SocialMediaFeed>> getSocialMediaLinks() async{
    var params={'event_id':widget.currEvent.event_id.toString()};
    var uri=Uri.https('delta.nitt.edu', '/recal-uae/api/events/social_media/',params);
    SharedPreferences prefs=await SharedPreferences.getInstance();
    var response=await http.get(
        uri,
        headers: {
          "Accept" : "application/json",
          "Cookie" : "${prefs.getString("cookie")}",
        }
    ) .then((_response) {
      ResponseBody responseBody = new ResponseBody();
      print('Response body: ${_response.body}');
      if (_response.statusCode == 200) {
        responseBody = ResponseBody.fromJson(json.decode(_response.body));
        if (responseBody.status_code == 200) {
          if(responseBody.data!=[]) {
            List<String> socialmediaIDs=[];
            for(var u in responseBody.data){
              socialmediaIDs.add(responseBody.data['socialmedia_id']);
            }
            //   getFeedUrl();
          }
        } else {
          print(responseBody.data);
        }
      } else {
        print('Server error');
      }
    });
  }

  getFeedUrl() async{
    var params={'event_id':'1'};
    var uri=Uri.https('delta.nitt.edu', '/recal-uae/api/events/social_media/',params);
    SharedPreferences prefs=await SharedPreferences.getInstance();
    var response=await http.get(
        uri,
        headers: {
          "Accept" : "application/json",
          "Cookie" : "${prefs.getString("cookie")}",
        }
    ) .then((_response) {
      ResponseBody responseBody = new ResponseBody();
      print('Response body: ${_response.body}');
      if (_response.statusCode == 200) {
        responseBody = ResponseBody.fromJson(json.decode(_response.body));
        if (responseBody.status_code == 200) {
          if(responseBody.data!=[]) {
            List<String> socialmediaIDs=[];
            for(var u in responseBody.data){
              socialmediaIDs.add(responseBody.data['socialmedia_id']);
            }
            getFeedUrl();
          }
        } else {
          print(responseBody.data);
        }
      } else {
        print('Server error');
      }
    });
  }

}

