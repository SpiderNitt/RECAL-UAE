import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:iosrecal/Constant/Constant.dart';
import 'package:iosrecal/Constant/utils.dart';
import 'package:iosrecal/screens/Events/Accounts.dart';
import 'package:iosrecal/screens/Events/EventPictureDisplay.dart';
import 'package:iosrecal/screens/Events/Felicitations.dart';
import 'package:iosrecal/models/EventDetailsInfo.dart';
import 'package:iosrecal/models/EventInfo.dart';
import 'package:iosrecal/models/FelicitationInfo.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/models/SponsorInfo.dart';
import 'package:iosrecal/models/Socialmedia_feed.dart';
import 'EventPhotos.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
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
  String flyerUrl;
  bool isSocialMediaEmpty = false;
  bool serverError = false;
  List<bool> fileServerError = [false,false,false];
  bool detailsLoading = true;
  List<bool> filesLoading = [true,true,true];
  bool detailsServerError = false;
  EventDetailsInfo detailsInfo;
  String baseURL = "https://delta.nitt.edu/recal-uae";
  String reminderUrl;
  List<String> picturesListUrl = [];
  List<String> carouselListUrl = [];
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
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

  Widget getBody() {
    if (!detailsLoading&& !(filesLoading[0]) &&!(filesLoading[1])&&!(filesLoading[2])) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: ColorGlobal.blueColor.withOpacity(0.5),
                      width: 2)),
              child: (!filesLoading[0] && !fileServerError[0]&&flyerUrl!=null) ?
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: flyerUrl,
                fit: BoxFit.fitWidth,
              ) : SizedBox(),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
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
                        style: TextStyle(color: Colors.blueGrey,fontSize: 15),
                      ),
                      Text(
                        getTime(),
                        style: TextStyle(color: Colors.blueGrey),
                      )
                    ],
                  ),
                ),
                widget.currEvent.event_name!=null?
                Column(
                  children: <Widget>[
                    SizedBox(height: 4,),
                    Container(
                      margin: EdgeInsets.only(left: 8,right:8),
                      child: AutoSizeText(widget.currEvent.event_name,
                        textAlign: TextAlign.center,
                        //overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 24,
                            fontWeight: FontWeight.bold,
                      color: ColorGlobal.textColor,
                        ),
                    )),
                  ],
                ):SizedBox(),
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
                            margin: EdgeInsets.only(left: 4,top:4),
                            child: (widget.currEvent.location == null &&
                                widget.currEvent.emirate == null)
                                ? Text(
                              "Location not available",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )
                                : Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: <Widget>[
                                widget.currEvent.emirate == null
                                    ? SizedBox(
                                  height: 6,
                                )
                                    : Container(
                                  width: UIUtills()
                                      .getProportionalWidth(width: 300),
                                      child: Text(
                                  widget.currEvent.emirate,
                                  style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 22,
                                        fontWeight:
                                        FontWeight.bold),
                                ),
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
                                        .emirate !=
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
                      detailsInfo != null ? detailsInfo.detail_message == ""
                          ? SizedBox()
                          : Container(
                          margin: EdgeInsets.only(top: 6,left: 2),
                          child: Text(
                            detailsInfo.detail_message,
                            style: TextStyle(
                                color: Colors.blueGrey, fontSize: 17),
                          )) : SizedBox(),
                      detailsInfo != null ? detailsInfo
                          .detail_amendment_message == ""
                          ? SizedBox()
                          : Container(
                          margin: EdgeInsets.only(top: 6),
                          child: Text(
                            detailsInfo.detail_amendment_message,
                            style: TextStyle(
                                color: Colors.black54, fontSize: 16),
                          )) : SizedBox(),
                      widget.isCompleted
                          ? Column(
                        children: <Widget>[
                          detailsInfo.detail_amendment_message != "" ?
                          SizedBox(
                            height: 20,
                          ) : SizedBox(height: 4,),
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
                                  onTap: () =>
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EventPhotos(picturesListUrl)))
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
                                      items: carouselListUrl.map((photo) {
                                        return Builder(
                                          builder:
                                              (BuildContext context) {
                                            return InkWell(
                                              child: Container(
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
                                                     photo,
                                                      fit: BoxFit.cover)),
                                                onTap: () =>
                                                {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => EventPictureDisplay(photo)))
                                                }
                                            );
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
                      Container(
                        margin: EdgeInsets.all(10),
                        child: (!filesLoading[1] && reminderUrl!=null) ?
                        FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: reminderUrl,
                          fit: BoxFit.fitWidth,
                        ) : SizedBox(),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                      ),
                      widget.isCompleted
                          ? SizedBox()
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          detailsInfo != null ? Container(
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
                                onTap: () =>
                                    launch(detailsInfo.registration_link),
                              )) : SizedBox(),
                        ],
                      ),
                      widget.isCompleted
                          ? SizedBox(height: 0)
                          : Column(
                        children: <Widget>[
                          detailsInfo != null ? detailsInfo.volunteer_message ==
                              "" ? SizedBox()
                              : SizedBox(height: 10) : SizedBox(),
                          detailsInfo != null ?
                          (detailsInfo.volunteer_message != "" ? Container(
                              child: Text(
                                detailsInfo.volunteer_message,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16),
                              )) : SizedBox()) : SizedBox(),
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
                            onPressed: () {
                  Navigator.pushNamed(context, VOLUNTEER_SUPPORT);
                                          },
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
                                      height: UIUtills().getProportionalHeight(
                                          height: 40),
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
                                    builder: (context) =>
                                        Accounts(
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
                                                    //color:Colors.black,
                                                    margin: EdgeInsets.only(
                                                        bottom: UIUtills()
                                                            .getProportionalHeight(
                                                            height: 6)),
                                                    child: snapshot.data[index]
                                                        .brochure != null
                                                        ? Image.network(
                                                      (baseURL+
                                                          snapshot.data[index]
                                                              .brochure
                                                              .toString()),
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
                                                              color: Colors
                                                                  .lightBlueAccent,
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    ):Container(height:UIUtills().getProportionalHeight(height: 300),color: Color(0xff4a4a4d),child:Image.asset("assets/images/sponsors.png",fit: BoxFit.scaleDown,)
                                                    )
                                                  ),
                                                ),
                                                snapshot.data[index]
                                                    .sponsor_name != null
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
                                                snapshot.data[index]
                                                    .contact_person_name != null
                                                    ? Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .center,
                                                  children: <Widget>[
                                                    Icon(Icons.phone),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 4),
                                                      child: Tooltip(
                                                        child: Container(
                                                          width:UIUtills()
                                                              .getProportionalWidth(width: 60),
                                                          child: Text(
                                                            snapshot.data[
                                                            index]
                                                                .contact_person_name,
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            maxLines: 1,
                                                          ),
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
                      FutureBuilder(
                        future: getSocialMediaLinks(),
                        builder: (BuildContext context,
                            AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                              return Container(width: 0, height: 2,);
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
                          else {
                            return Column(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Text("Event Links"),
                                    ],
                                  ),
                                  margin: EdgeInsets.only(left: 4),),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4.0),
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.06,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        return getIcon(snapshot.data[index].platform
                                            .toString(),
                                            snapshot.data[index].feed_url
                                                .toString());
                                      }),
                                ),
                              ],
                            );
                          }
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }
    else if (detailsLoading || filesLoading[0]||filesLoading[1]||filesLoading[2]) {
      return Center(
        child: SpinKitDoubleBounce(
          color: Colors.lightBlueAccent,
        ),
      );
    }
    else if (detailsServerError || fileServerError[0]||fileServerError[1]||fileServerError[2]) {
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
    String id = widget.currEvent.emirate;
    String emirate;
    switch (id) {
      case '1':
        emirate = "Umm Al Quwain";
        break;
      case '2':
        emirate = "Sharjah";
        break;
      case '3':
        emirate = "Ras Al Khaimah";
        break;
      case '4':
        emirate = "Fujairah";
        break;
      case '5':
        emirate = "Dubai";
        break;
      case '6':
        emirate = "Ajman";
        break;
      case '7':
        emirate = "Abu Dhabi";
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
          if (responseBody.data.length != 0) {
            for (var u in responseBody.data) {
              SocialMediaFeed currInfo = SocialMediaFeed.fromJson(u);
              socialmediafeeds.add(currInfo);
            }
            return socialmediafeeds;
          }
          else {
            print('Social Media Empty');
            isSocialMediaEmpty = true;
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
    if (socialmediafeeds.length != 0) {
      return socialmediafeeds;
    }
  }

  @override
  void initState() {
    super.initState();
    getEventFile("flyer");
    getEventFile("pictures");
   getEventFile("reminder");
    getEventDetails();
  }

  Widget getIcon(String socialMediaName, String feed_url) {
    String iconLocation;
    if (socialMediaName.toLowerCase() == "instagram") {
      iconLocation = 'assets/images/instagram.png';
    } else if (socialMediaName.toLowerCase() == "facebook") {
      iconLocation = 'assets/images/facebook.png';
    } else if (socialMediaName.toLowerCase() == "twitter") {
      iconLocation = 'assets/images/twitter.png';
    } else if (socialMediaName.toLowerCase() == "youtube") {
      iconLocation = 'assets/images/youtube.png';
    } else if (socialMediaName.toLowerCase() == "linkedin") {
      iconLocation = 'assets/images/linkedin.png';
    }
    if (iconLocation != null) {
      return InkWell(
        child: Container(
          margin: EdgeInsets.only(left: 8, right: 8),
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
    } else {
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

    var uri = Uri.https(
        'delta.nitt.edu', '/recal-uae/api/events/manage/', params);
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
              detailsInfo = EventDetailsInfo(
                  detail_amendment_message: responseBody
                      .data['detail_amendment_message'],
                  detail_message: responseBody.data['detail_message'],
                  registration_link: responseBody.data['registration_link'],
                  volunteer_message: responseBody.data['volunteer_message']);
              detailsLoading = false;
            });
            print("yayy" + responseBody.data.toString());
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

  Future<List<SponsorInfo>> getSponsors() async {
    var params = {'event_id': widget.currEvent.event_id.toString()};
    List<SponsorInfo> sponsorsList = [];
    var uri = Uri.https(
        'delta.nitt.edu', '/recal-uae/api/events/sponsors/', params);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        uri,
        headers: {
          "Accept": "application/json",
          "Cookie": "${prefs.getString("cookie")}",
        }
    ).then((_response) {
      ResponseBody responseBody = new ResponseBody();
      print('Response body: sp ${_response.body}');
      if (_response.statusCode == 200) {
        responseBody = ResponseBody.fromJson(json.decode(_response.body));
        if (responseBody.status_code == 200) {
          if (responseBody.data.length != 0) {
            for (var u in responseBody.data) {
              SponsorInfo model = SponsorInfo.fromJson(u);
              sponsorsList.add(model);
            }
            print(sponsorsList.length.toString());
            return sponsorsList;
          }
          else {
            print("empty");
            isEmpty = true;
            return 1;
          }
        } else {
          print(responseBody.data);
          return 2;
        }
      } else {
        print('Server error');
        serverError = true;
        return 3;
      }
    });
    if (sponsorsList.length != 0) {
      return sponsorsList;
    }
  }
  Future<List<String>> getEventFile(String file_type) async {
    var params = {
      'event_id': widget.currEvent.event_id.toString(),
      'file_type': file_type
    };
    
    var uri = Uri.https(
        'delta.nitt.edu', '/recal-uae/api/events/get_file/', params);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        uri,
        headers: {
          "Accept": "application/json",
          "Cookie": "${prefs.getString("cookie")}",
        }
    ).then((_response) {
      ResponseBody responseBody = new ResponseBody();
      print('Response body: photos ${_response.body}');
      if (_response.statusCode == 200) {
        responseBody = ResponseBody.fromJson(json.decode(_response.body));
        if (responseBody.status_code == 200) {
          if (responseBody.data.length != 0) {
            setState(() {
              if (file_type == "flyer") {
                if(responseBody.data['file']!=null)
                { filesLoading[0] = false;
                  flyerUrl = baseURL + responseBody.data['file'].toString();}
              }else if(file_type=="reminder"){
                filesLoading[1]=false;
                if(responseBody.data['file']!=null)
                {reminderUrl = baseURL + responseBody.data['file'].toString();}
              }else{
                if(responseBody.data['file']!=null)
                  {filesLoading[2]=false;
                  int cnt=0;
                  for(var u in responseBody.data['file']) {
                    cnt++;
                    if(cnt<=10){
                      carouselListUrl.add(baseURL+u.toString());
                    }
                    print(u.toString());
                   picturesListUrl.add(baseURL+u.toString());
              print("picturesList"+picturesListUrl.length.toString());}
              }}
            });
            return picturesListUrl;
          }
          else {
            setState(() {
              if(file_type=="flyer")
              {filesLoading[0] = false;}else if(file_type=="reminder"){
                filesLoading[1]=false;
              }else{
                filesLoading[2]=false;
              }
            });
            return 1;
          }
        } else {
          print(responseBody.data);
          return 2;
        }
      } else {
        print('Server error');
        setState(() {
          if(file_type=="flyer")
          {fileServerError[0] = false;}else if(file_type=="reminder"){
            fileServerError[1]=false;
          }else{
            fileServerError[2]=false;
          }
        });
        return 3;
      }
    });
    if (picturesListUrl.length != 0) {
      return picturesListUrl;
    }
  }
}

