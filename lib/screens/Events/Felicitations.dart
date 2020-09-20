import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/Constant/Constant.dart';
import 'package:iosrecal/Endpoint/Api.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/screens/Home/NoInternet.dart';
import 'package:iosrecal/screens/Home/errorWrong.dart';
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
  int internet = 1;
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
                      child:Text("No felicitations for this event",style:GoogleFonts.josefinSans(fontSize: 22,color: ColorGlobal.textColor,fontStyle: FontStyle.italic))
                  );
                }else if(internet==0){
                  return (Center(child:NoInternetScreen()));
                }
                else if(serverError){
                  return Center(
                      child:Error8Screen()
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
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        internet = 0;
      });
    }

    List<FelicitationModel> felicitationList=[];
    var uri=Uri.parse(Api.getFelicitations);
    uri = uri.replace(query: "event_id="+widget.event_id.toString());
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
        } else if(responseBody.status_code==401){
          onTimeOut();
        }else {
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
  Future<bool> onTimeOut(){
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Session Timeout'),
        content: new Text('Login to continue'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () async {
              navigateAndReload();
            },
            child: FlatButton(
              color: Colors.red,
              child: Text("OK"),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  navigateAndReload(){
    Navigator.pushNamed(context, LOGIN_SCREEN, arguments: true)
        .then((value) {
      print("step 1");
      int param=widget.event_id;
      Navigator.pop(context);
      print("step 2");
      Felicitations(param);});
  }
}
