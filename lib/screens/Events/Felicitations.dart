import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iosrecal/models/FelicitationInfo.dart';
class Felicitations extends StatefulWidget {
  int event_id;
  Felicitations(this.event_id);
  @override
  _FelicitationsState createState() => _FelicitationsState();
}

class _FelicitationsState extends State<Felicitations> {
  bool isEmpty=false;
  bool checkData=false;
  bool serverError=false;
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Felicitations",style:TextStyle(color: ColorGlobal.textColor)),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
              color: ColorGlobal.textColor
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
          child:
          FutureBuilder(
            future: getFelicitations(),
            builder: (BuildContext context,AsyncSnapshot snapshot){
              if(snapshot.data==null){
                if(isEmpty){
                  return Center(
                      child:Text("No felicitations for this event",style:GoogleFonts.josefinSans(fontSize: 20,color: ColorGlobal.textColor))
                  );
                }
                else if(serverError){
                  return Center(
                      child:Text("Server Error.. Try again after some time",style: GoogleFonts.josefinSans(fontSize: 20,color: ColorGlobal.textColor))
                  );
                }
                else {
                  return Center(
                    child: SpinKitDoubleBounce(
                      color: ColorGlobal.blueColor,
                    ),
                  );
                }
              }
              else{
                return Container(
                  margin: EdgeInsets.only(top: 10),
                  child:ListView.builder(
                      itemCount: snapshot.data.length, itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 5,
                                blurRadius: 50.0,
                                offset: Offset(
                                    0, // Move to right 10  horizontally
                                    0.75// Move to bottom 5 Vertically
                                ),
                                color: Colors.black12
                            )
                          ],
                          color:ColorGlobal.color2,
                          borderRadius: BorderRadius.circular(20.0)),
                      margin: EdgeInsets.only(top: 6,bottom: 6),
                      child: Padding(
                        padding: const EdgeInsets.only(top:8.0,bottom: 8,left: 8,right: 8),
                        child: ExpansionTile(
                          backgroundColor: Colors.white,
                          leading: CircleAvatar(
                            radius: 24,
                            child: Icon(Icons.person,size: 36,),
                          ),
                          title: snapshot.data[index].felicitated_person!=null?Text(
                            snapshot.data[index].felicitated_person,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 20.0, color: Colors.black87),
                          ):SizedBox(),
                          trailing: Icon(
                            Icons.keyboard_arrow_down,
                            color: ColorGlobal.textColor,
                          ),
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.all(6),child: snapshot.data[index].achievement!=null?Text(snapshot.data[index].achievement,style: TextStyle(fontSize: 18),):Text("Not available"))
                          ],
                        ),
                      ),
                    );
                  }),
                );
              }
            },
          ),
        ),
      ),
    );
  }
  Future<List<FelicitationModel>> getFelicitations() async{
    var params={'event_id':widget.event_id.toString()};
    List<FelicitationModel> felicitationList=[];
    var uri=Uri.https('delta.nitt.edu','/recal-uae/api/events/felicitations/',params);
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
