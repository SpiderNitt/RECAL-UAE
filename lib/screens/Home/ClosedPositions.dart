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
    return positions;
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

  @override
  Widget build(BuildContext context) {
    String uri;
    final double width = MediaQuery.of(context).size.width;
//    TimeoutArguments args = ModalRoute.of(context).settings.arguments;
//    print("checking args");
//    if(args!=null && args.auth){
//      print("positions again");
//      _positions();
//    }
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
                                            Text(closedPositions[index].position,
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
                                          Text(closedPositions[index].company,
                                              style: TextStyle(
                                                  color: ColorGlobal.textColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20.0))
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 24.0),
                                  AutoSizeText(
                                    closedPositions[index].description,
                                    style: TextStyle(color: ColorGlobal.textColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0),
                                    maxLines: 10,
                                  ),
                                  SizedBox(
                                    height: 24.0,
                                  ),
                                  Column(
                                    children: [
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
                                                    closedPositions[index].contact;
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
                                                  Text(closedPositions[index].contact,
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
