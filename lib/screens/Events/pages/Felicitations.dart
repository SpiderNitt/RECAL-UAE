import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/routes.dart';
import 'package:iosrecal/constants/UIUtility.dart';
import 'package:iosrecal/constants/Api.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/widgets/NoInternet.dart';
import 'package:iosrecal/widgets/Error.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iosrecal/models/FelicitationInfo.dart';
import 'dart:io' show Platform;
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
  bool isCreated=false;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    UIUtility().updateScreenDimesion(
        width: screenSize.width, height: screenSize.height);
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
          leading: IconButton(
              icon: Icon(
                Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                color: ColorGlobal.textColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: isCreated?Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
          child:
          FutureBuilder(
            future: getFelicitations(),
            builder: (BuildContext context,AsyncSnapshot snapshot){
              if(snapshot.data==null){
                if(isEmpty){
                  return Center(
                      child:Text("No felicitations for this event",style:GoogleFonts.josefinSans(fontSize: UIUtility()
                          .getProportionalWidth(
                          width: 22),color: ColorGlobal.textColor))
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
                          borderRadius: BorderRadius.circular(UIUtility()
                              .getProportionalWidth(
                              width: 20),)),
                      margin: EdgeInsets.only(top: 6,bottom: 6),
                      child: Padding(
                        padding: const EdgeInsets.only(top:8.0,bottom: 8,left: 8,right: 8),
                        child: ExpansionTile(
                          backgroundColor: Colors.white,
                          leading: CircleAvatar(
                            radius: UIUtility()
                                .getProportionalWidth(
                                width: 24),
                            child: Icon(Icons.person,size: UIUtility()
                                .getProportionalWidth(
                                width: 30),),
                          ),
                          title: snapshot.data[index].felicitated_person!=null?Text(
                            snapshot.data[index].felicitated_person,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize:UIUtility()
                                    .getProportionalWidth(
                                    width: 18) , color: Colors.black87),
                          ):SizedBox(),
                          trailing: Icon(
                            Icons.keyboard_arrow_down,
                            color: ColorGlobal.textColor,
                          size: UIUtility()
                              .getProportionalWidth(
                              width: 22),),
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.all(6),child: snapshot.data[index].achievement!=null?Text(snapshot.data[index].achievement,style: TextStyle(fontSize: UIUtility()
                                .getProportionalWidth(
                                width: 18)),):Text("Not available"))
                          ],
                        ),
                      ),
                    );
                  }),
                );
              }
            },
          ),
        ):SizedBox(),
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

  @override
  void initState() {
    setState(() {
      isCreated=true;
    });
  }

  navigateAndReload(){
    Navigator.pushNamed(context, LOGIN_SCREEN, arguments: true)
        .then((value) {
      int param=widget.event_id;
      Navigator.pop(context,true);
      Felicitations(param);
      setState(() {
        isCreated=true;
      });
        });
  }
}
