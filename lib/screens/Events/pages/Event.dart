import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:iosrecal/routes.dart';
import 'package:iosrecal/constants/UIUtility.dart';
import 'package:iosrecal/constants/Api.dart';
import 'package:iosrecal/screens/Events/widgets/EventPictureDisplay.dart';
import 'package:iosrecal/screens/Events/pages/Felicitations.dart';
import 'package:iosrecal/models/EventDetailsInfo.dart';
import 'package:iosrecal/models/EventInfo.dart';
import 'dart:io' show Platform;
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/models/SponsorInfo.dart';
import 'package:iosrecal/models/Socialmedia_feed.dart';
import 'package:iosrecal/widgets/NoInternet.dart';
import 'package:iosrecal/widgets/Error.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import '../widgets/EventPhotos.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
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
  bool isEmpty = false;
  String flyerUrl;
  bool isSocialMediaEmpty = false;
  bool serverError = false;
  List<bool> fileServerError = [false,false,false];
  bool detailsLoading = true;
  List<bool> filesLoading = [true,true,true];
  bool detailsServerError = false;
  EventDetailsInfo detailsInfo;
  String reminderUrl;
  List<String> picturesListUrl = [];
  List<String> carouselListUrl = [];
  String firstHalf;
  String secondHalf;
  int internet=1;
  bool flag = true;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    UIUtility().updateScreenDimesion(
        width: screenSize.width, height: screenSize.height);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
                color: ColorGlobal.textColor
            ),
            title: Text("Event Details",
                style: TextStyle(color: ColorGlobal.textColor)),
            leading: IconButton(
                icon: Icon(
                  Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                  color: ColorGlobal.textColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            backgroundColor: ColorGlobal.whiteColor,
          ),
          body:internet==0?NoInternetScreen(notifyParent: refresh):(widget.isCompleted!=true&& (!detailsLoading&& !(filesLoading[0]) &&!(filesLoading[1])&&!(filesLoading[2])))?
          SlidingSheet(
            body: getBody(),
            elevation: 4,
            cornerRadius: 16,
            snapSpec: const SnapSpec(
              snap: true,
              snappings: [0.15, 0.15, 1.0],
              positioning: SnapPositioning.relativeToAvailableSpace,
            ),
            builder: (context, state) {
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                         SizedBox(height: UIUtility()
                             .getProportionalHeight(
                             height: 4),),
                       Divider(
                         thickness: 3,
                         color: Colors.grey.withOpacity(0.8),
                         indent: UIUtility()
                             .getProportionalWidth(
                             width: 165),
                         endIndent: UIUtility()
                             .getProportionalWidth(
                             width: 165),
                       ),
                        Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: detailsInfo != null ? Container(
                                child: detailsInfo.registration_link == ""
                                    ? SizedBox() :
                                RaisedButton(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: UIUtility()
                                            .getProportionalWidth(
                                            width: 24),
                                      ),
                                      SizedBox(
                                        width: UIUtility()
                                            .getProportionalWidth(
                                            width: 10),
                                      ),
                                      Text(
                                        "Register",
                                        style: TextStyle(color: Colors.white,fontSize: UIUtility()
                                            .getProportionalWidth(
                                            width: 16),),
                                      ),
                                    ],
                                  ),
                                  onPressed: ()=>launch(detailsInfo.registration_link),
                                  color: Colors.blue[800],
                                ),
                              ) : SizedBox(),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.people,
                                    color: Colors.white,
                                    size: UIUtility()
                                        .getProportionalWidth(
                                        width: 24),
                                  ),
                                  SizedBox(
                                    width: UIUtility()
                                        .getProportionalWidth(
                                        width: 10),
                                  ),
                                  Text(
                                    "Volunteer",
                                    style: TextStyle(color: Colors.white,fontSize: UIUtility()
                                        .getProportionalWidth(
                                        width: 16),),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, VOLUNTEER_SUPPORT);
                              },
                              color: Colors.blue[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                       detailsInfo != null ?
                       (detailsInfo.volunteer_message != "" ? Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Row(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                             CircleAvatar(
                               radius: UIUtility()
                                   .getProportionalHeight(
                                   height: 30),
                               child: Container(
                                   child: Image.asset( "assets/images/volunteer.png",fit: BoxFit.cover,)
                               ),
                             ),
                             Expanded(
                               child: Container(
                                   margin: EdgeInsets.only(left: 6),
                                   child: Text(
                                     detailsInfo.volunteer_message,
                                     style: TextStyle(
                                         color: Colors.black87,
                                         fontSize: UIUtility()
                                             .getProportionalHeight(
                                             height: 16)),
                                   )),
                             ),
                           ],
                         ),
                       ) : SizedBox()) : SizedBox(),
                       SizedBox(height: UIUtility()
                           .getProportionalHeight(
                           height: 10),),
                  ],
                ),
              );
            },
          ):getBody()
      ),
    );
  }

  Widget getBody() {
    if (!detailsLoading&& !(filesLoading[0]) &&!(filesLoading[1])&&!(filesLoading[2])) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              child:Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: ColorGlobal.blueColor.withOpacity(0.5),
                      width: 2)),
              child: (!filesLoading[0] && !fileServerError[0]&&flyerUrl!=null) ?
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: flyerUrl,
                fit: BoxFit.cover,
              ) : SizedBox(),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .width/2,
            ),
                onTap: () =>
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventPictureDisplay(flyerUrl)))
                }
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding:const EdgeInsets.only(top: 8.0, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        getDate(),
                        style: TextStyle(color: Colors.blueGrey,fontSize: UIUtility()
                            .getProportionalWidth(
                            width: 16)),
                      ),
                      Text(
                        getTime(),
                        style: TextStyle(color: Colors.blueGrey,fontSize: UIUtility()
                            .getProportionalWidth(
                            width: 16)),
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
                            margin:EdgeInsets.only(left:5),
                            child: Icon(
                              Icons.place,
                              size: UIUtility()
                                  .getProportionalWidth(
                                  width: 30),
                              color: ColorGlobal.blueColor
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
                                  fontSize: UIUtility().getProportionalWidth(width: 16),
                                  fontWeight: FontWeight.bold),
                            )
                                : Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: <Widget>[
                                widget.currEvent.emirate == null
                                    ? SizedBox(
                                  height: UIUtility()
                                      .getProportionalHeight(
                                      height: 6),
                                )
                                    : Container(
                                  width: UIUtility()
                                      .getProportionalWidth(width: 300),
                                      child: Text(
                                  widget.currEvent.emirate,
                                  style: TextStyle(
                                        color: Colors.black54,
                                        fontSize:  UIUtility()
                                            .getProportionalWidth(
                                            width: 15),
                                        fontWeight:
                                        FontWeight.bold),
                                ),
                                    ),
                                Container(
                                  width: UIUtility()
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
                                        fontSize:  UIUtility()
                                            .getProportionalWidth(
                                            width: 15))
                                        : TextStyle(
                                        color: Colors.black54,
                                        fontSize:  UIUtility()
                                            .getProportionalWidth(
                                            width: 15),
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
                widget.currEvent.event_name!=null?
                Column(
                  children: <Widget>[
                    SizedBox(height: UIUtility()
                        .getProportionalHeight(
                        height: 4),),
                    Container(
                        margin: EdgeInsets.only(left: 8,right:8,top:4),
                        child: AutoSizeText(widget.currEvent.event_name.toUpperCase(),
                          textAlign: TextAlign.center,
                          //overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: GoogleFonts.lato(fontSize:  UIUtility()
                              .getProportionalWidth(
                              width: 20),
                            fontWeight: FontWeight.w700,
                            color: ColorGlobal.textColor,
                          ),
                        )),
                  ],
                ):SizedBox(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12,0,8,8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      widget.currEvent.event_description!=""?Container(margin:EdgeInsets.only(top: 8,bottom: 4),child: Text("DESCRIPTION",style:TextStyle(fontWeight: FontWeight.w600,color:ColorGlobal.textColor.withOpacity(0.8),fontSize: UIUtility()
                          .getProportionalWidth(
                          width: 16)))):SizedBox(),
                      widget.currEvent.event_description!=""?
                      secondHalf.isEmpty
    ? Container(
                          child: Text(firstHalf,style:  GoogleFonts.roboto(fontSize:  UIUtility()
                              .getProportionalWidth(
                              width: 15),color: ColorGlobal.textColor),))
        :  Column(
    children: <Widget>[
     Container(
         child: Text(flag ? (firstHalf + "...") : (firstHalf + secondHalf),style:  GoogleFonts.roboto(fontSize:  UIUtility()
             .getProportionalWidth(
             width: 15),color: ColorGlobal.textColor),)),
     InkWell(
    child: Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      Text(
    flag ? "show more" : "show less",
    style: new TextStyle(color: Colors.blue,fontSize:  UIUtility()
        .getProportionalWidth(
        width: 14)),
    ),
    ],
    ),
    onTap: () {
    setState(() {
    flag = !flag;
    });
    },
    ),
    ],
    ):SizedBox(),
                      Divider(
                        thickness: 1,
                        endIndent: UIUtility()
                            .getProportionalWidth(
                            width: 5),
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      detailsInfo != null ? detailsInfo.detail_message ==""
                          ? SizedBox()
                          : Container(
                        margin: EdgeInsets.only(bottom: 4),
                          child: Text(
                                 detailsInfo.detail_message,
                            style: TextStyle(
                                color: Colors.black54, fontSize:  UIUtility()
                                .getProportionalWidth(
                                width: 15)),
                          )) : SizedBox(),
                      SizedBox(
                        height: UIUtility()
                            .getProportionalHeight(
                            height: 4),
                      ),

                      detailsInfo != null ? detailsInfo
                          .detail_amendment_message ==""
                          ? SizedBox(height: UIUtility()
                          .getProportionalHeight(
                          height: 4))
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(top: 2),
                              child: Stack(
    children: <Widget>[
      Card(child:Padding(
          padding:EdgeInsets.fromLTRB(20,12,8,8),
          child:Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Text(
                "AMENDMENT MESSAGE",
                  style: TextStyle(
                      color: ColorGlobal.textColor.withOpacity(0.8), fontSize:  UIUtility()
                      .getProportionalWidth(
                      width: 16),fontWeight: FontWeight.w600),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      detailsInfo.detail_amendment_message,
                      style: TextStyle(
                          color: Colors.black54, fontSize:  UIUtility()
                          .getProportionalWidth(
                          width: 15)),
                    ),
                  ],
                ),
              ],
            ),
          )  )
      ),
      Container(margin: EdgeInsets.only(left: 0),child:Icon(Icons.add_to_photos,color: Colors.green,size:UIUtility()
          .getProportionalWidth(
          width: 24),),)
    ],
    ))
                        ],
                      ) : SizedBox(),
                      widget.isCompleted
                          ? Column(
                        children: <Widget>[
                          detailsInfo.detail_amendment_message != "" ?
                          SizedBox(
                            height: UIUtility()
                                .getProportionalHeight(
                                height: 10),
                          ) : SizedBox(height: UIUtility()
                              .getProportionalHeight(
                              height: 4),),
picturesListUrl.length>0?  Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text("EVENT GALLERY",style:TextStyle(fontWeight: FontWeight.w600,color:ColorGlobal.textColor.withOpacity(0.8),fontSize: UIUtility()
                                      .getProportionalWidth(
                                      width: 16)))),
                              carouselListUrl.length>5?InkWell(
                                  child: Text("More",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,color:Colors.indigo,fontSize:  UIUtility()
                                          .getProportionalWidth(
                                          width: 14))),
                                  onTap: () =>
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EventPhotos(picturesListUrl)))
                                  }):SizedBox(),
                            ],
                          ):SizedBox(),
                          picturesListUrl.length>0? Column(
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
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .width/3,
                                      width: MediaQuery.of(context).size.width,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: carouselListUrl.length>5?5:carouselListUrl.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  child: Container(
                                                      width: UIUtility()
                                                          .getProportionalWidth(
                                                          width: 120),
                                                      height: UIUtility()
                                                          .getProportionalWidth(
                                                          width: 120),
                                                      margin: EdgeInsets
                                                          .symmetric(
                                                          horizontal: 6),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: ColorGlobal.blueColor.withOpacity(0.5),
                                                              width: 2)),
                                                      child: Image.network(
                                                          carouselListUrl[index],
                                                          fit: BoxFit.cover)),
                                                ),
                                                onTap: () =>
                                                {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => EventPictureDisplay(carouselListUrl[index])))
                                                }
                                            );
                                          }),
                                    ),

                                  ],
                                ),
                              ),
                              SizedBox(height: UIUtility()
                                  .getProportionalHeight(
                                  height: 10),),
                            ],
                          ):SizedBox(height: 0,),
                        ],
                      )
                          : SizedBox(),
                      Divider(
                        thickness: 1,
                        endIndent: UIUtility()
                            .getProportionalWidth(
                            width: 5),
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: (!filesLoading[1] && reminderUrl!=null) ?
                        Column(
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width/2,
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: reminderUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                                onTap: () =>
                                {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EventPictureDisplay(reminderUrl)))
                                }
                            ),
                            SizedBox(height: UIUtility()
                                .getProportionalHeight(
                                height: 10),),
                          ],
                        ) : SizedBox(),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,),
                      Column(
                        children: <Widget>[
                      widget.isCompleted
                          ? Column(
                        children: <Widget>[
                          SizedBox(
                            height: 0,
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
                                            "assets/images/felicitation.png",
                                            fit: BoxFit.cover,
                                          ),
                                          height:  UIUtility()
                                              .getProportionalHeight(
                                              height: 36),
                                        ),
                                        Container(
                                          height: UIUtility()
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
                                                      fontWeight: FontWeight.w600,
                                                      fontSize:  UIUtility()
                                                          .getProportionalWidth(
                                                          width: 16)),
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
                                height: UIUtility()
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
                        height: UIUtility()
                            .getProportionalHeight(
                            height: 10),
                      ),

                      FutureBuilder(
                        future: getSponsors(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                            if (isEmpty) {
                              return Row(
                                children: <Widget>[
                                  Text(
                                    "No Sponsors for this event",
                                    style: TextStyle(color: Colors.black38,fontSize:  UIUtility()
                                        .getProportionalWidth(
                                        width: 14)),
                                  ),
                                ],
                              );
                            } else if (serverError) {
                              return Center(
                                  child: Text(
                                    "Server Error..Try again after sometime",
                                    style: TextStyle(color: Colors.blueGrey,fontSize: UIUtility()
                                        .getProportionalWidth(
                                        width: 14)),
                                  ));
                            } else {
                              return Center(
                                child: SpinKitDoubleBounce(
                                  color: ColorGlobal.blueColor,
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
                                      child: Text("EVENT SPONSORS",style:TextStyle(fontWeight: FontWeight.w600,color:ColorGlobal.textColor.withOpacity(0.8),fontSize: UIUtility()
                                          .getProportionalWidth(
                                          width: 16))),),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: UIUtility()
                                          .getProportionalWidth(width: 4),
                                      vertical: UIUtility()
                                          .getProportionalHeight(height: 6)),
                                  height: UIUtility()
                                      .getProportionalHeight(height: 200),
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          width: UIUtility()
                                              .getProportionalWidth(
                                              width: 150),
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
                                                          bottom: UIUtility()
                                                              .getProportionalHeight(
                                                              height: 6)),
                                                      child: snapshot.data[index]
                                                          .brochure != null
                                                          ? InkWell(
                                                            child: Image.network(
                                                        (Api.imageUrl+
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
                                                                  color: ColorGlobal.blueColor,
                                                                ),
                                                              );
                                                            }
                                                        },
                                                      ),
                                                        onTap: ()=>{
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => EventPictureDisplay(Api.imageUrl+
                                                                      snapshot.data[index]
                                                                          .brochure
                                                                          .toString())))
                                                        },
                                                          ) :Container(height:UIUtility().getProportionalHeight(height: 300),color: Color(0xff4a4a4d),child:Image.asset("assets/images/sponsors.png",fit: BoxFit.scaleDown,)
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
                                                      fontSize:  UIUtility()
                                                          .getProportionalWidth(
                                                          width: 15),
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
                                                    Icon(Icons.phone,size:  UIUtility()
                                                        .getProportionalHeight(
                                                        height: 20),),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 4),
                                                      child: Tooltip(
                                                        child: Container(
                                                          width:UIUtility()
                                                              .getProportionalWidth(width: 60),
                                                          child: Text(
                                                            snapshot.data[
                                                            index]
                                                                .contact_person_name,
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(fontSize:  UIUtility()
                                                                .getProportionalWidth(
                                                                width: 15)),
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
                          }
                          else {
                            return Column(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(left: 4),
                                          child: Text("EVENT LINKS",style:TextStyle(fontWeight: FontWeight.w600,color:ColorGlobal.textColor.withOpacity(0.8),fontSize: UIUtility()
                                              .getProportionalWidth(
                                              width: 16))),
                                      )
                                    ],
                                  ),
                                  margin: EdgeInsets.only(left: 4,top:4),),
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
                ])
                )],
            ),
            SizedBox(height:  widget.isCompleted!=true?
            100:UIUtility().getProportionalHeight(height: 0)),
          ],
        ),
      );
    }
    else if (detailsLoading || filesLoading[0]||filesLoading[1]||filesLoading[2]) {
      return Center(
        child: SpinKitDoubleBounce(
          color: ColorGlobal.blueColor,
        ),
      );
    }
    else if (detailsServerError || fileServerError[0]||fileServerError[1]||fileServerError[2]) {
      return Center(
          child: Error8Screen()
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
    return emirate;
  }

  Future<List<SocialMediaFeed>> getSocialMediaLinks() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
        internet=0;
    }
    else {
        internet=1;
    }
    var uri=Uri.parse(Api.getSocialMedia);
    uri = uri.replace(query: "event_id="+widget.currEvent.event_id.toString());
    List<SocialMediaFeed> socialmediafeeds = [];
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
        }else {
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
    if (widget.currEvent.event_description!=""&&widget.currEvent.event_description.length > 200) {
      firstHalf = widget.currEvent.event_description.substring(0, 200);
      secondHalf = widget.currEvent.event_description.substring(200, widget.currEvent.event_description.length);
    } else {
      firstHalf = widget.currEvent.event_description;
      secondHalf = "";
    }
  }
  refresh() {
    getEventFile("flyer");
    getEventFile("pictures");
    getEventFile("reminder");
    getEventDetails();
    if (widget.currEvent.event_description!=""&&widget.currEvent.event_description.length > 200) {
      firstHalf = widget.currEvent.event_description.substring(0, 200);
      secondHalf = widget.currEvent.event_description.substring(200, widget.currEvent.event_description.length);
    } else {
      firstHalf = widget.currEvent.event_description;
      secondHalf = "";
    }
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
      bool param1 = widget.isCompleted;
      EventInfo param2=widget.currEvent;
      Navigator.pop(context,true);
      Event(param1,param2);
      getEventFile("flyer");
      getEventFile("pictures");
      getEventFile("reminder");
      getEventDetails();
      if (widget.currEvent.event_description!=""&&widget.currEvent.event_description.length > 200) {
        firstHalf = widget.currEvent.event_description.substring(0, 200);
        secondHalf = widget.currEvent.event_description.substring(200, widget.currEvent.event_description.length);
      } else {
        firstHalf = widget.currEvent.event_description;
        secondHalf = "";
      }});
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
            height:  UIUtility()
                .getProportionalHeight(height: 26),
            width:  UIUtility()
                .getProportionalWidth(width: 26),
            fit: BoxFit.scaleDown,
            image: AssetImage(
                iconLocation),
            alignment: Alignment.center,
          ),
        ),
        onTap: () => launch(feed_url),
      );
    } else {
      return Tooltip(
        child: Container(
          margin: EdgeInsets.only(left: 4),
          child: Card(
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
                                fontSize:24,
                                fontWeight:
                                FontWeight.bold),
                          ),
                          onTap: () => launch(feed_url),
                        )),
                  ),
                ),
              ),
            ),
          ),
        ),
        message:socialMediaName ,
      );
    }
  }

  Future<dynamic> getEventDetails() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        internet = 0;
      });
    }
    else {
      setState(() {
        internet=1;
      });
    }
    var uri=Uri.parse(Api.getManage);
    uri = uri.replace(query: "event_id="+widget.currEvent.event_id.toString());
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
            return detailsInfo;
          } else {
            setState(() {
              detailsLoading = false;
            });
            return 1;
          }
        } else if(responseBody.status_code==401){
          onTimeOut();
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

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
        internet=0;
    }
    else {
        internet=1;
    }
    var uri=Uri.parse(Api.getSponsors);
    uri = uri.replace(query: "event_id="+widget.currEvent.event_id.toString());
    List<SponsorInfo> sponsorsList = [];
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
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
     setState(() {
       internet = 0;
     });
    }
    else {
      setState(() {
        internet=1;
      });
    }
    String url=Api.getFile+"?event_id="+widget.currEvent.event_id.toString()+"&file_type="+file_type;
    var uri=Uri.parse(url);
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
                  flyerUrl = Api.imageUrl + responseBody.data['file'].toString();}
              }else if(file_type=="reminder"){
                filesLoading[1]=false;
                if(responseBody.data['file']!=null)
                {reminderUrl = Api.imageUrl + responseBody.data['file'].toString();}
              }else{
                if(responseBody.data['file']!=null)
                  {filesLoading[2]=false;
                  int cnt=0;
                  for(var u in responseBody.data['file']) {
                    cnt++;
                    if(cnt<=10){
                      carouselListUrl.add(Api.imageUrl+u.toString());
                    }
                   picturesListUrl.add(Api.imageUrl+u.toString());
           }
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
        }else {
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

