import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/PositionModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Constant/ColorGlobal.dart';

class OpenPositions extends StatefulWidget {
  @override
  _OpenPositionsState createState() => _OpenPositionsState();
}

class _OpenPositionsState extends State<OpenPositions> {
  var positions = new List<PositionModel>();
  var openPositions = new List<PositionModel>();

  initState() {
    super.initState();
    //_positions();
  }

  Future<List> _positions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        "https://delta.nitt.edu/recal-uae/api/employment/positions",
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

      }
      //print("Intial length : " + positions.length.toString());
      positions.forEach((element) {
        print(element.company);
        if(!DateTime.now().isAfter(DateTime.parse(element.open_until))){
          openPositions.add(element);
        }

      });
    }
    return positions;
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
                  return Center(child: Text("Try Again!"));
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return Center(
                    child: SpinKitDoubleBounce(
                      color: Colors.lightBlueAccent,
                    ),
                  );
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Center(child: Text("Try Again!"));
                  } else {
                    print(openPositions.length);
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
