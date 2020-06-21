import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './Event.dart';
import '../Constant/ColorGlobal.dart';
import '../Constant/ColorGlobal.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class VolunteerCard extends StatefulWidget {
  bool isCompleted = false,attended=false;
  String num;
  VolunteerCard(bool check,String tag,bool at) {
    if (check) {
      isCompleted = true;
    }
    num=tag;
    attended = at;
  }

  @override
  _VolunteerCardState createState() => _VolunteerCardState();
}

class _VolunteerCardState extends State<VolunteerCard> {
  @override
  Widget build(BuildContext context) {
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
                        child: Text(
                          "RECAL UAE Meet",
                          maxLines: 1,
                          style: TextStyle(
                              color: ColorGlobal.color2,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        margin: EdgeInsets.only(
                            left: 14, top: 6, right: 4, bottom: 2),
                    ),
                    widget.isCompleted==true ?
                    Container(
                        margin: EdgeInsets.only(top: 6),
                        child:widget.attended==true? Icon(Icons.check_circle,color: Colors.green,) : Icon(Icons.cancel,color: Colors.red,),
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
                                Text(
                                  "September 20, 2020",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 3),
                                  child: Text(
                                    "10am - 5pm",
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
                        Navigator.push(context, MaterialPageRoute(builder:(context)=>Event(widget.isCompleted,widget.num)));
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
}
//ExpansionTile(
//title: Container(
//child: Column(
//children: <Widget>[
//Row(
//crossAxisAlignment: CrossAxisAlignment.start,
////mainAxisAlignment: MainAxisAlignment.spaceBetween,
//children: <Widget>[
//Icon(Icons.event_note,size: 32,color: Colors.black
//,),
//
//Container(
//margin: EdgeInsets.only(left:4),
//child: Column(
//crossAxisAlignment: CrossAxisAlignment.start,
//children: <Widget>[
//Text("September 20, 2020",
//style: TextStyle(
//color: Colors.black54,
//fontSize: 16,
//fontWeight: FontWeight.bold
//),),
//Container(
//margin: EdgeInsets.only(top: 3),
//child: Text(
//"10am - 5pm",
//style: TextStyle(
//color: Colors.black45,
//),
//),
//),
//],
//),
//),
//],
//),
//],
//),
//),
//
//children: <Widget>[
//Column(
//crossAxisAlignment: CrossAxisAlignment.start,
//children: <Widget>[
//Container(child: Image.network("https://picsum.photos/seed/picsum/500/600",fit: BoxFit.cover,)),
//Container(child: Text("LOCATION"),margin: EdgeInsets.only(top:4,left: 12,bottom:4),),
//Container(child: Text("EMIRATE"),margin: EdgeInsets.only(left: 12,bottom:8),),
//Container(
//margin: EdgeInsets.only(left: 12,bottom:8),
//child: Text(
//"This event is intended to mark asgjhg jlkjl gfthbniu ccygmomm vhij"
//"ffjhk kh gbom,p.jvgvhh "
//),
//),
//isCompleted?SizedBox(height: 0,width: 0,):
//Column(
//children: <Widget>[
//InkWell(
//child: Text("Register here"),
//onTap: () async{
////                         if (await canLaunch("url")){
////                           await launch("url");
////                         }else{
////                           throw 'could not launch link';
////                         }
//},
//),
//Text("Want to Volunteer?",style: TextStyle(color:Colors.black),),
//Row(
//mainAxisAlignment: MainAxisAlignment.spaceAround,
//children: <Widget>[
//OutlineButton(
//child: Padding(
//padding: const EdgeInsets.only(left:36.0,right: 36),
//child: Text("Accept",style: TextStyle(color: Colors.green),),
//),
//onPressed: (){},
//color: Colors.white,
//borderSide: BorderSide(color: Colors.green,style: BorderStyle.solid,width: 0.8),
//),
//OutlineButton(
//child: Padding(
//padding: const EdgeInsets.only(left:36.0,right:36.0),
//child: Text("Decline",style: TextStyle(color: Colors.red[700]),),
//),
//onPressed: (){},
//color: Colors.white,
//borderSide: BorderSide(color: Colors.red[700],style: BorderStyle.solid,width: 0.8),
//
//
//),
//],
//),],),
//],
//),
//],
//
//
//)
