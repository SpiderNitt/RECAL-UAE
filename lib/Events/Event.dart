import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iosrecal/Constant/utils.dart';
import 'package:iosrecal/Events/Accounts.dart';
import 'package:iosrecal/Events/Felicitations.dart';
import 'package:iosrecal/models/EventDetailsInfo.dart';
import 'package:iosrecal/models/EventInfo.dart';
import 'package:iosrecal/models/FelicitationInfo.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/models/SponsorInfo.dart';
import '../models/Socialmedia_feed.dart';
import './EventPhotos.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import '../Constant/ColorGlobal.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Event extends StatefulWidget {
  bool isCompleted = false;
  EventInfo currEvent;

  Event(this.isCompleted, this.currEvent);

  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  final List<int> numbers = [1, 2, 3, 4, 5, 5, 2, 3, 5];
  bool isEmpty = false;
  bool isSocialMediaEmpty=false;
  bool serverError = false;
  bool detailsLoading=true;
  bool detailsServerError=false;
  EventDetailsInfo detailsInfo;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    UIUtills().updateScreenDimesion(
        width: screenSize.width, height: screenSize.height);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            titleSpacing: -5,
            iconTheme: IconThemeData(
                color: ColorGlobal.textColor
            ),
            title: Text("Event Details",
                style: TextStyle(color: ColorGlobal.textColor)),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: ColorGlobal.textColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: ColorGlobal.whiteColor,
          ),
          body: getBody()
      ),
    );
  }
  Widget getBody(){
    if(detailsLoading==false){
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: ColorGlobal.blueColor.withOpacity(0.5),
                      width: 2)),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: "https://picsum.photos/300",
                fit: BoxFit.fitWidth,
              ),
              width: MediaQuery.of(context).size.width,
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding:
                  const EdgeInsets.only(top: 8.0, left: 10, right: 10),
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
                            child: (widget.currEvent.location == null &&
                                widget.currEvent.emirate_id == null)
                                ? Text(
                              "Location not available",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            )
                                : Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: <Widget>[
                                widget.currEvent.emirate_id == null
                                    ? SizedBox(
                                  height: 6,
                                )
                                    : Text(
                                  getEmirate(),
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 24,
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                                Container(
                                  width: UIUtills()
                                      .getProportionalWidth(width: 300),
                                  margin: EdgeInsets.only(top: 3),
                                  child: widget.currEvent.location !=
                                      null
                                      ? Text(
                                    widget.currEvent.location,
                                    maxLines: 5,
                                    overflow:
                                    TextOverflow.ellipsis,
                                    style: widget.currEvent
                                        .emirate_id !=
                                        null
                                        ? TextStyle(
                                        color: Colors.black45,
                                        fontSize: 16)
                                        : TextStyle(
                                        color: Colors.black54,
                                        fontSize: 22,
                                        fontWeight:
                                        FontWeight.bold),
                                  )
                                      : SizedBox(),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      detailsInfo!=null?detailsInfo.detail_message == ""
                          ? SizedBox()
                          : Container(
                          margin: EdgeInsets.only(top: 6),
                          child: Text(
                            detailsInfo.detail_message,
                            style: TextStyle(
                                color: Colors.blueGrey, fontSize: 17),
                          )):SizedBox(),
                      detailsInfo!=null?detailsInfo.detail_amendment_message == ""
                          ? SizedBox()
                          : Container(
                          margin: EdgeInsets.only(top: 6),
                          child: Text(
                            detailsInfo.detail_amendment_message,
                            style: TextStyle(
                                color: Colors.black54, fontSize: 16),
                          )):SizedBox(),
                      widget.isCompleted
                          ? Column(
                        children: <Widget>[
                          detailsInfo.detail_amendment_message!=""?
                          SizedBox(
                            height: 20,
                          ):SizedBox(height: 0,),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(left: 4),
                                  child: Text(
                                    "Event Photos",
                                    style: TextStyle(fontSize: 16),
                                  )),
                              InkWell(
                                  child: Text("More",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EventPhotos()))
                                  })
                            ],
                          ),
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 6),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: <Widget>[
                                    CarouselSlider(
                                      options: CarouselOptions(
                                          height: UIUtills()
                                              .getProportionalHeight(
                                              height: 180),
                                          initialPage: 0,
                                          enlargeCenterPage: true,
                                          enableInfiniteScroll: false),
                                      items: numbers.map((sponsor) {
                                        return Builder(
                                          builder:
                                              (BuildContext context) {
                                            return Container(
                                                width: UIUtills()
                                                    .getProportionalWidth(
                                                    width: 300),
                                                margin: EdgeInsets
                                                    .symmetric(
                                                    horizontal: 6),
                                                decoration:
                                                BoxDecoration(
                                                    color: Colors
                                                        .white),
                                                child: Image.network(
                                                    "https://picsum.photos/300",
                                                    fit: BoxFit.cover));
                                          },
                                        );
                                      }).toList(),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                          : SizedBox(),
                      widget.isCompleted
                          ? SizedBox()
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          detailsInfo!=null?Container(
                              margin: EdgeInsets.only(top: 4),
                              child: detailsInfo.registration_link == ""
                                  ? SizedBox()
                                  : InkWell(
                                child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.touch_app,
                                          color:
                                          ColorGlobal.color2),
                                      Text("Register here",
                                          style: TextStyle(
                                              color: ColorGlobal
                                                  .color2,
                                              fontSize: 16))
                                    ]),
                                onTap: () => launch(detailsInfo.registration_link),
                              )):SizedBox(),
                        ],
                      ),
                      widget.isCompleted
                          ? SizedBox(height: 0)
                          : Column(
                        children: <Widget>[
                          detailsInfo!=null?detailsInfo.volunteer_message=="" ? SizedBox()
                              :SizedBox(height: 10):SizedBox(),
                          detailsInfo!=null?
                          (detailsInfo.volunteer_message!=""? Container(
                              child: Text(
                                detailsInfo.volunteer_message,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16),
                              )):SizedBox()):SizedBox(),
                          OutlineButton(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Volunteer",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                            onPressed: () {},
                            color: Colors.white,
                            borderSide: BorderSide(
                                color: Colors.green,
                                style: BorderStyle.solid,
                                width: UIUtills()
                                    .getProportionalWidth(width: 0.8)),
                          ),
                        ],
                      ),
                      widget.isCompleted
                          ? Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Card(
                            child: InkWell(
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Image.asset(
                                          "assets/images/felicitation.png",
                                          fit: BoxFit.cover,
                                        ),
                                        Container(
                                          height: UIUtills()
                                              .getProportionalHeight(
                                              height: 50),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 12),
                                                child: Text(
                                                  "Felicitations",
                                                  style: TextStyle(
                                                      color: ColorGlobal
                                                          .textColor,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                        margin:
                                        EdgeInsets.only(right: 4),
                                        child: Icon(
                                            Icons.keyboard_arrow_right))
                                  ],
                                ),
                                height: UIUtills()
                                    .getProportionalHeight(height: 50),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Felicitations(widget
                                                .currEvent.event_id)));
                              },
                            ),
                          ),
                        ],
                      )
                          : SizedBox(),
                      SizedBox(
                        height: 5,
                      ),
                      Card(
                        child: InkWell(
                          child: Container(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      child: Image.asset(
                                        "assets/images/survey.png",
                                        fit: BoxFit.cover,
                                      ),
                                      height: UIUtills().getProportionalHeight(height: 40),
                                    ),
                                    Container(
                                      height: UIUtills()
                                          .getProportionalHeight(height: 50),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            ColorGlobal.whiteColor,
                                            ColorGlobal.whiteColor
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(left: 12),
                                            child: Text(
                                              "Accounts",
                                              style: TextStyle(
                                                  color:
                                                  ColorGlobal.textColor,
                                                  fontSize: 20),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                    margin: EdgeInsets.only(right: 4),
                                    child: Icon(Icons.keyboard_arrow_right))
                              ],
                            ),
                            height:
                            UIUtills().getProportionalHeight(height: 50),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Accounts(
                                        widget.currEvent.event_id)));
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FutureBuilder(
                        future: getSponsors(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                            if (isEmpty) {
                              return Row(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(left: 4),
                                          child: Text("Sponsors : ")),
                                    ],
                                  ),
                                  Text(
                                    "No Sponsors for this event",
                                    style: TextStyle(color: Colors.black38),
                                  ),
                                ],
                              );
                            } else if (serverError) {
                              return Center(
                                  child: Text(
                                    "Server Error..Try again after sometime",
                                    style: TextStyle(color: Colors.blueGrey),
                                  ));
                            } else {
                              return Center(
                                child: SpinKitDoubleBounce(
                                  color: Colors.lightBlueAccent,
                                ),
                              );
                            }
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(left: 4),
                                        child: Text(
                                          "Sponsors",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: UIUtills()
                                          .getProportionalWidth(width: 4),
                                      vertical: UIUtills()
                                          .getProportionalHeight(height: 6)),
                                  height: UIUtills()
                                      .getProportionalHeight(height: 288),
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          width: UIUtills()
                                              .getProportionalWidth(
                                              width: 216),
                                          child: Card(
                                            //color: Colors.blue,
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: UIUtills()
                                                            .getProportionalHeight(
                                                            height: 6)),
                                                    child: Image.network(
                                                      "https://picsum.photos/300",
                                                      fit: BoxFit.cover,
                                                      loadingBuilder:
                                                          (BuildContext ctx,
                                                          Widget child,
                                                          ImageChunkEvent
                                                          loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        } else {
                                                          return Center(
                                                            child:
                                                            SpinKitDoubleBounce(
                                                              color: Colors.lightBlueAccent,
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                snapshot.data[index].sponsor_name!=null
                                                    ? Tooltip(
                                                  child: Text(
                                                    snapshot.data[index]
                                                        .sponsor_name,
                                                    maxLines: 2,
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                  ),
                                                  message: snapshot
                                                      .data[index]
                                                      .sponsor_name,
                                                  waitDuration:
                                                  Duration(
                                                      milliseconds:
                                                      0),
                                                )
                                                    : SizedBox(),
                                                snapshot.data[index].contact_person_name!=null ? Row(
                                                  mainAxisAlignment:MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(Icons.phone),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 4),
                                                      child: Tooltip(
                                                        child: Text(
                                                          snapshot.data[
                                                          index].contact_person_name,
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        message: snapshot
                                                            .data[index]
                                                            .contact_person_name,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                                    : SizedBox(),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      //                     //sample
                      // Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      // children: <Widget>[
                      // Row(
                      // children: <Widget>[
                      // Container(
                      // margin: EdgeInsets.only(left: 4),
                      // child: Text(
                      // "Sponsors",
                      // style: TextStyle(
                      // fontWeight: FontWeight.bold),
                      // )),
                      // ],
                      // ),
                      // Container(
                      // padding: EdgeInsets.symmetric(
                      // horizontal: UIUtills()
                      //     .getProportionalWidth(width: 4),
                      // vertical: UIUtills()
                      //     .getProportionalHeight(height: 6)),
                      // height: UIUtills()
                      //     .getProportionalHeight(height: 288),
                      // child: ListView.builder(
                      // scrollDirection: Axis.horizontal,
                      // itemCount: numbers.length,
                      // itemBuilder: (context, index) {
                      // return Container(
                      // width: UIUtills()
                      //     .getProportionalWidth(
                      // width: 216),
                      // child: Card(
                      // //color: Colors.blue,
                      // child: Column(
                      // mainAxisAlignment:
                      // MainAxisAlignment.center,
                      // children: <Widget>[
                      // Expanded(
                      // child: Container(
                      // margin: EdgeInsets.only(
                      // bottom: UIUtills()
                      //     .getProportionalHeight(
                      // height: 6)),
                      // child: Image.network(
                      // "https://picsum.photos/300",
                      // fit: BoxFit.cover,
                      // loadingBuilder:
                      // (BuildContext ctx,
                      // Widget child,
                      // ImageChunkEvent
                      // loadingProgress) {
                      // if (loadingProgress ==
                      // null) {
                      // return child;
                      // } else {
                      // return Center(
                      // child:
                      // SpinKitDoubleBounce(
                      // color: Colors
                      //     .lightBlueAccent,
                      // ),
                      // );
                      // }
                      // },
                      // ),
                      // ),
                      // ),
                      //  Tooltip(
                      // child: Text(
                      //
                      //     "Sponsor name",
                      // maxLines: 2,
                      // overflow:
                      // TextOverflow
                      //     .ellipsis,
                      // style: TextStyle(
                      // fontWeight:
                      // FontWeight
                      //     .bold),
                      // ),
                      // message: "sponsor_name",
                      // waitDuration:
                      // Duration(
                      // milliseconds:
                      // 0),
                      // ),
                      //
                      //  Row(
                      // mainAxisAlignment:
                      // MainAxisAlignment
                      //     .center,
                      // children: <Widget>[
                      // Icon(Icons.phone),
                      // Container(
                      // margin: EdgeInsets
                      //     .only(
                      // left: 4),
                      // child: Tooltip(
                      // child: Text(
                      //
                      //     "contact person",
                      // overflow:
                      // TextOverflow
                      //     .ellipsis,
                      // ),
                      // message:
                      //     "contact_person",
                      // ),
                      // ),
                      // ],
                      // )
                      // ],
                      // ),
                      // ),
                      // );
                      // }),
                      // ),
                      // ],
                      // ),
                      (isSocialMediaEmpty)==false?Container(child: Text("Event Links"),margin: EdgeInsets.only(left: 4),):SizedBox(height: 4,),
                      FutureBuilder(
                        future: getSocialMediaLinks(),
                        builder: (BuildContext context,AsyncSnapshot snapshot){
                          if(snapshot.data==null){
                            if(isSocialMediaEmpty){
                              return SizedBox();
                            }else{
                              return Container(width: 0,height: 0,);
                            }
                            // else if(serverError){
                            //   return Center(
                            //       child:Text("Server Error..Try again after some time",style: TextStyle(color: Colors.blueGrey,fontSize: 16),)
                            //   );
                            // }
                            // else {
                            //   return Center(
                            //     child: SpinKitDoubleBounce(
                            //       color: Colors.lightBlueAccent,
                            //     ),
                            //   );
                            // }
                          }
                          else{
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.0),
                              height:MediaQuery.of(context).size.height * 0.06,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return getIcon(snapshot.data[index].platform.toString(),snapshot.data[index].feed_url.toString());
                                  }),
                            );
                          }
                        },
                      )
                      // //sample
                      //                     Container(
                      // margin: EdgeInsets.only(top: 0.5),
                      // padding: EdgeInsets.symmetric(
                      // horizontal: 16.0, vertical: 4.0),
                      // height:
                      // MediaQuery.of(context).size.height * 0.08,
                      // child: ListView.builder(
                      // scrollDirection: Axis.horizontal,
                      // itemCount: numbers.length,
                      // itemBuilder: (context, index) {
                      // return Card(
                      // color: ColorGlobal.color2,
                      // child: Container(
                      // child: Card(
                      // elevation: 2,
                      // clipBehavior: Clip.antiAlias,
                      // shape: RoundedRectangleBorder(
                      // borderRadius:
                      // BorderRadius.circular(10)),
                      // child: Container(
                      // color: ColorGlobal.textColor,
                      // padding: EdgeInsets.all(5),
                      // child: FittedBox(
                      // fit: BoxFit.fitWidth,
                      // child: Center(
                      // child: InkWell(
                      // child: Text(
                      // "Facebook",
                      // style: TextStyle(
                      // color: ColorGlobal
                      //     .whiteColor,
                      // fontSize: 15,
                      // fontWeight:
                      // FontWeight.bold),
                      // ),
                      // onTap: () => launch("https://www.facebook.com/"),
                      // )),
                      // ),
                      // ),
                      // ),
                      // ),
                      // );
                      // }),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }
    else if(detailsLoading){
      return Center(
        child: SpinKitDoubleBounce(
          color: Colors.lightBlueAccent,
        ),
      );
    }
    else if(detailsServerError){
      return Center(
          child: Text(
              "Server Error..Try again after sometime", style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16
          ))
      );
    }
  }
  String getDate() {
    var date = DateTime.parse(widget.currEvent.datetime);
    var updateddate = DateFormat.yMMMMd().format(date);
    return updateddate;
  }

  String getTime() {
    var date = DateTime.parse(widget.currEvent.datetime);
    var updateddate = DateFormat.jm().format(date);
    return updateddate;
  }

  String getEmirate() {
    String id = widget.currEvent.emirate_id;
    String emirate;
    switch (id) {
      case '1':
        emirate = "Dubai";
        break;
      case '2':
        emirate = "Abu Dhabi";
        break;
      case '3':
        emirate = "Ajman";
        break;
      case '4':
        emirate = "Fujairah";
        break;
      case '5':
        emirate = "Ras Al Khaimah";
        break;
      case '6':
        emirate = "Sharjah";
        break;
      case '7':
        emirate = "Umm Al Quwain";
        break;
    }
    print(emirate);
    return emirate;
  }

  Future<List<SocialMediaFeed>> getSocialMediaLinks() async {
    var params = {'event_id': widget.currEvent.event_id.toString()};
    List<SocialMediaFeed> socialmediafeeds = [];
    var uri = Uri.https(
        'delta.nitt.edu', '/recal-uae/api/events/social_media/', params);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(uri, headers: {
      "Accept": "application/json",
      "Cookie": "${prefs.getString("cookie")}",
    }).then((_response) {
      ResponseBody responseBody = new ResponseBody();
      print('Response body:socialmedia ${_response.body}');
      if (_response.statusCode == 200) {
        responseBody = ResponseBody.fromJson(json.decode(_response.body));
        if (responseBody.status_code == 200) {
          if (responseBody.data.length!=0) {
            for (var u in responseBody.data) {
              SocialMediaFeed currInfo = SocialMediaFeed.fromJson(u);
              socialmediafeeds.add(currInfo);
            }
            return socialmediafeeds;
          }
          else{
            print('Social Media Empty');
            isSocialMediaEmpty=true;
            return 1;
          }
        } else {
          print(responseBody.data);
          return 2;
        }
      } else {
        print('Server error');
        return 3;
      }
    });
    if(socialmediafeeds.length!=0){return socialmediafeeds;}
  }

  @override
  void initState() {
    super.initState();
    getEventDetails();
  }
  Widget getIcon(String socialMediaName,String feed_url){
    String iconLocation;
    if(socialMediaName.toLowerCase()=="instagram"){
      iconLocation='assets/images/instagram.png';
    }    else if(socialMediaName.toLowerCase()=="facebook"){
      iconLocation='assets/images/facebook.png';
    }else if(socialMediaName.toLowerCase()=="twitter"){
      iconLocation='assets/images/twitter.png';
    }else if(socialMediaName.toLowerCase()=="youtube"){
      iconLocation='assets/images/youtube.png';
    }else if(socialMediaName.toLowerCase()=="linkedin"){
      iconLocation='assets/images/linkedin.png';
    }
    if(iconLocation!=null){
      return InkWell(
        child: Container(
          margin: EdgeInsets.only(left: 8,right: 8),
          child: Image(
            height: 26.0,
            width: 26.0,
            fit: BoxFit.scaleDown,
            image: AssetImage(
                iconLocation),
            alignment: Alignment.center,
          ),
        ),
        onTap: () => launch(feed_url),
      );
    }else{
      return Card(
        color: ColorGlobal.color2,
        child: Container(
          child: Card(
            elevation: 2,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(10)),
            child: Container(
              color: ColorGlobal.textColor,
              padding: EdgeInsets.all(5),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Center(
                    child: InkWell(
                      child: Text(
                        socialMediaName,
                        style: TextStyle(
                            color: ColorGlobal
                                .whiteColor,
                            fontSize: 15,
                            fontWeight:
                            FontWeight.bold),
                      ),
                      onTap: () => launch(feed_url),
                    )),
              ),
            ),
          ),
        ),
      );
    }
  }
  Future<dynamic> getEventDetails() async {
    var params = {'event_id': widget.currEvent.event_id.toString()};

    var uri =Uri.https('delta.nitt.edu', '/recal-uae/api/events/manage/', params);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(uri, headers: {
      "Accept": "application/json",
      "Cookie": "${prefs.getString("cookie")}",
    }).then((_response) {
      ResponseBody responseBody = new ResponseBody();
      print('Response body: event details ${_response.body}');
      if (_response.statusCode == 200) {
        responseBody = ResponseBody.fromJson(json.decode(_response.body));
        if (responseBody.status_code == 200) {
          if (responseBody.data.length != 0) {
            setState(() {
              detailsInfo=EventDetailsInfo(
                  detail_amendment_message: responseBody.data['detail_amendment_message'],
                  detail_message: responseBody.data['detail_message'],
                  registration_link: responseBody.data['registration_link'],
                  volunteer_message: responseBody.data['volunteer_message']);
              detailsLoading=false;
            });
            print("yayy"+responseBody.data.toString());
            return detailsInfo;
          } else {
            setState(() {
              detailsLoading = false;
            });
            return 1;
          }
        } else {
          print(responseBody.data);
          return 2;
        }
      } else {
        setState(() {
          detailsServerError = true;
        });
        print('Server error');
        return 3;
      }
    });
  }

  Future<dynamic> getSponsors() async {
    var params = {'event_id': widget.currEvent.event_id.toString()};
    List<SponsorInfo> sponsorList = [];
    var uri =
    Uri.https('delta.nitt.edu', '/recal-uae/api/events/sponsors/',params);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(uri, headers: {
      "Accept": "application/json",
      "Cookie": "${prefs.getString("cookie")}",
    }).then((_response) {
      ResponseBody responseBody = new ResponseBody();
      print('Response body: sponsors ${_response.body}');
      if (_response.statusCode == 200) {
        responseBody = ResponseBody.fromJson(json.decode(_response.body));
        if (responseBody.status_code == 200) {
          if (responseBody.data.length != 0) {
            for (var u in responseBody.data) {
              SponsorInfo model= SponsorInfo.fromJson(u);
              sponsorList.add(model);
            }
            return sponsorList;
          } else {
            isEmpty = true;
            return 1;
          }
        } else {
          print(responseBody.data);
          return 2;
        }
      } else {
        serverError = true;
        print('Server error');
        return 3;
      }
    });
    if(sponsorList.length!=0){return sponsorList;}
  }
  Future<List<FelicitationModel>> getFelicitations() async{
    var params={'event_id':widget.currEvent.event_id.toString()};
    List<FelicitationModel> felicitationList=[];
    var uri=Uri.https('delta.nitt.edu', '/recal-uae/api/events/felicitations/',params);
    SharedPreferences prefs=await SharedPreferences.getInstance();
    var response=await http.get(
        uri,
        headers: {
          "Accept" : "application/json",
          "Cookie" : "${prefs.getString("cookie")}",
        }
    ) .then((_response) {
      ResponseBody responseBody = new ResponseBody();
      print('Response body: felicitations ${_response.body}');
      if (_response.statusCode == 200) {
        responseBody = ResponseBody.fromJson(json.decode(_response.body));
        if (responseBody.status_code == 200) {
          if(responseBody.data.length!=0) {
            for(var u in responseBody.data) {
              FelicitationModel model= FelicitationModel.fromJson(u);
              felicitationList.add(model);
            }
            print(felicitationList.length.toString());
            return felicitationList;
          }
          else{
            print("empty");
            isEmpty=true;
            return 1;
          }
        } else {
          print(responseBody.data);
          return 2;
        }
      } else {
        print('Server error');
        serverError=true;
        return 3;
      }
    });
    if(felicitationList.length!=0){return felicitationList;}
  }
}

