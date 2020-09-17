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
import 'package:connectivity/connectivity.dart';

class OpenPositions extends StatefulWidget {
  @override
  _OpenPositionsState createState() => _OpenPositionsState();
}

class _OpenPositionsState extends State<OpenPositions> {
  var positions = new List<PositionModel>();
  var openPositions = new List<PositionModel>();
  int internet = 1;
  int error = 0;

  initState() {
    super.initState();
    //_positions();
  }

  Future<List> _positions() async {
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
      print("success");
//        updateCookie(_response);
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      if (responseBody.status_code == 200) {
        List list = responseBody.data;
        positions = list.map((model) => PositionModel.fromJson(model)).toList();

        positions.forEach((element) {
          print(element.company);
          if(!DateTime.now().isAfter(DateTime.parse(element.open_until))){
            openPositions.add(element);
          }

        });

      }else if(responseBody.status_code==401){
        onTimeOut();
      }else{
        error =1;
      }

    }else{
      error = 1;
    }
    return positions;
  }

  navigateAndReload(){
    Navigator.pushNamed(context, LOGIN_SCREEN, arguments: true)
        .then((value) {
      print("step 1");
      Navigator.pop(context);
      setState(() {

      });
      print("step 2");

      _positions();});
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


  @override
  Widget build(BuildContext context) {
    String uri;
    final double width = MediaQuery.of(context).size.width;

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
            'Open Positions',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: Center(
          child: FutureBuilder(
            future: _positions(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(child: NoInternetScreen());
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return Center(
                    child: SpinKitDoubleBounce(
                      color: Colors.lightBlueAccent,
                    ),
                  );
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return internet == 1 ? Center(child: Error8Screen()) : Center(child: NoInternetScreen());
                  } else {
                    if(error==1){
                      return Center(child: Error8Screen());
                    }
                    if(openPositions.length==0){
                      return Center(child: NodataScreen());
                    }
                    return ListView.builder(
                      itemCount: openPositions.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Material(
                            color: Colors.white,
                            elevation: 14.0,
                            shadowColor: Color(0x802196F3),
                            borderRadius: BorderRadius.circular(24.0),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                children: [
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.business_center,
                                        size: 40.0,
                                        color: Color(0xfff4c83f),
                                      ),
                                      SizedBox(
                                        width: 12.0,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Position',
                                              style: TextStyle(
                                                  color: Color(0xfff4c83f),
                                                  fontSize: 13.0)),
                                          Text(openPositions[index].position,
                                              style: TextStyle(
                                                  color:
                                                  ColorGlobal.textColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20.0))
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 24.0,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.business,
                                        size: 40.0,
                                        color: Color(0xffed622b),
                                      ),
                                      SizedBox(
                                        width: 12.0,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Company',
                                              style: TextStyle(
                                                  color: Color(0xffed622b),
                                                  fontSize: 13.0)),
                                          Text(openPositions[index].company,
                                              style: TextStyle(
                                                  color: ColorGlobal.textColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20.0))
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 24.0),
                                  Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: Text(
                                          openPositions[index].description,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: ColorGlobal.textColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.0,
                                          ),
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 24.0,
                                  ),
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.phone_android,
                                        size: 40.0,
                                        color: Color(0xcc982ef0),
                                      ),
                                      SizedBox(
                                        width: 12.0,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          uri = "tel://" +
                                              openPositions[index].contact;
                                          launch(uri);
                                        },
                                        child: Column(
                                          //mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Contact',
                                                style: TextStyle(
                                                    color:
                                                    Color(0xcc982ef0),
                                                    fontSize: 13.0)),
                                            Text(openPositions[index].contact,
                                                style: TextStyle(
                                                    color: ColorGlobal
                                                        .textColor,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    fontSize: 20.0)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 24.0,
                                  ),
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.access_time,
                                        size: 40.0,
                                        color: Color(0xcc26cb3c),
                                      ),
                                      SizedBox(
                                        width: 12.0,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Open Until',
                                              style: TextStyle(
                                                  color: Color(0xcc26cb3c),
                                                  fontSize: 13.0)),
                                          Text(openPositions[index].open_until,
                                              style: TextStyle(
                                                  color:
                                                  ColorGlobal.textColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20.0))
                                        ],
                                      ),
                                    ],
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
