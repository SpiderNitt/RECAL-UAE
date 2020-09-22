import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/Constant/Constant.dart';
import 'package:iosrecal/models/PositionModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/screens/Home/NoInternet.dart';
import 'package:iosrecal/screens/Home/errorWrong.dart';
import 'package:iosrecal/screens/Home/NoData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:iosrecal/Endpoint/Api.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity/connectivity.dart';
import 'package:iosrecal/Constant/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClosedPositions extends StatefulWidget {
  @override
  _ClosedPositionsState createState() => _ClosedPositionsState();
}

class _ClosedPositionsState extends State<ClosedPositions> {
  var positions = new List<PositionModel>();
  var closedPositions = new List<PositionModel>();
  int internet = 1;
  int error = 0;
  UIUtills uiUtills = new UIUtills();

  initState() {
    super.initState();
    uiUtills = new UIUtills();
    //_positions();
  }

  Future<List> _positions() async {
    closedPositions = new List<PositionModel>();
    positions = new List<PositionModel>();
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      internet = 0;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        Api.getPosition,
        headers: {
          "Accept": "application/json",
          "Cookie": "${prefs.getString("cookie")}",
        });
    ResponseBody responseBody = new ResponseBody();
    if (response.statusCode == 200) {
//        updateCookie(_response);
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      if (responseBody.status_code == 200) {
        List list = responseBody.data;
        positions = list.map((model) => PositionModel.fromJson(model)).toList();

        positions.forEach((element) {
          print(element.company);
          if(DateTime.now().isAfter(DateTime.parse(element.open_until))){
            closedPositions.add(element);
          }
        });

      }else if(responseBody.status_code==401){
        onTimeOut();
      }else{
        error =1;
      }
      //print("Intial length : " + positions.length.toString());

    }else{
      error = 1;
    }
    return closedPositions;
  }

  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }

  Future<bool> onTimeOut(){
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Session Timeout'),
        content: new Text('Login to continue'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () async {
              //await _logoutUser();
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
          Navigator.pop(context);
          setState(() {

          });
          _positions();});
  }

  refresh(){
    setState(() {

    });
    _positions;
  }

  @override
  Widget build(BuildContext context) {
    String uri;
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    print("width : " + width.toString());
    print("height : " + height.toString());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorGlobal.whiteColor,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: ColorGlobal.textColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'Closed Positions',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: Center(
          child: FutureBuilder (
            future: _positions(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(child: NoInternetScreen(notifyParent: refresh));
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return Center(
                    child: SpinKitDoubleBounce(
                      color: Colors.lightBlueAccent,
                    ),
                  );
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return internet == 1 ? Center(child: Error8Screen()) : Center(child: NoInternetScreen(notifyParent: refresh));
                  }
                  else {
                    print("error is : " + error.toString());
                    print(closedPositions.length);
                    if(error==1){
                      return Center(child: Error8Screen());
                    }
                    else if(closedPositions.length==0){
                      return Center(child: NodataScreen());
                    }
                    return ListView.builder(
                      itemCount: closedPositions.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width/25, vertical: width/50),
                          child: Material(
                            color: Colors.white,
                            elevation: 14.0,
                            shadowColor: Color(0x802196F3),
                            borderRadius: BorderRadius.circular(3*width/50),
                            child: Padding(
                              padding: EdgeInsets.all(3*width/50),
                              child: Column(
                                children: [
                                  Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.business_center,
                                          size: width/10,
                                          color: Color(0xfff4c83f),
                                        ),
                                        SizedBox(
                                          width: 3*width/100,
                                        ),
                                        Container(
                                          width: 67*width/100,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              AutoSizeText('Position',
                                                  style: TextStyle(
                                                      color: Color(0xfff4c83f),
                                                      fontSize: getHeight(13,2)),
                                                maxLines: 1,
                                              ),
                                              AutoSizeText(
                                                closedPositions[index].position,
                                                  style: TextStyle(
                                                      color:
                                                          ColorGlobal.textColor,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: getHeight(20,2)),
                                              maxLines: 1,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                  ),
                                  SizedBox(
                                    height: 3*width/50,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.business,
                                        size: width/10,
                                        color: Color(0xffed622b),
                                      ),
                                      SizedBox(
                                        width: 3*width/100,
                                      ),
                                      Container(
                                        width: 67*width/100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            AutoSizeText('Company',
                                                style: TextStyle(
                                                    color: Color(0xffed622b),
                                                    fontSize: getHeight(13,2)),
                                            maxLines: 1,
                                            ),
                                            AutoSizeText(closedPositions[index].company,
                                                style: TextStyle(
                                                    color: ColorGlobal.textColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: getHeight(20,2)),
                                            maxLines: 1,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 3*width/50,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.description,
                                        size: width/10,
                                        color: Color(0xcc982ef0),
                                      ),
                                      SizedBox(
                                        width: 3*width/100,
                                      ),
                                      Container(
                                        width: 67*width/100,
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            AutoSizeText('Description',
                                              style: TextStyle(
                                                  color: Color(0xcc982ef0),
                                                  fontSize: getHeight(13,2)),
                                              maxLines: 1,
                                            ),
                                            AutoSizeText(closedPositions[index].description,
                                              style: TextStyle(
                                                  color: ColorGlobal.textColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: getHeight(20,2)),
                                              maxLines: 7,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 3*width/50,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
              };
              return Center(child: Text("Try Again!"));
            },
          ),
        ),
      ),
    );
  }
}
