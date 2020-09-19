import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/Constant/Constant.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/models/ResumeWriteModel.dart';
import 'package:iosrecal/screens/Home/NoInternet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iosrecal/screens/Home/errorWrong.dart';
import 'package:iosrecal/screens/Home/NoData.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:iosrecal/Endpoint/Api.dart';
import 'package:connectivity/connectivity.dart';

class WriteResume extends StatefulWidget {
  @override
  _WriteResumeState createState() => _WriteResumeState();
}

class _WriteResumeState extends State<WriteResume> {
  var writers = new List<ResumeWriteModel>();
  int internet = 1;
  int error = 0;

  initState() {
    super.initState();
  }

  navigateAndReload(){
    Navigator.pushNamed(context, LOGIN_SCREEN, arguments: true)
        .then((value) {
      Navigator.pop(context);
      setState(() {

      });
      getResumeWriters();});
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

  Future<List> getResumeWriters() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      internet = 0;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        Api.writeResume,
        headers: {
          "Accept": "application/json",
          "Cookie": "${prefs.getString("cookie")}",
        }
    );
    ResponseBody responseBody = new ResponseBody();

    if (response.statusCode == 200) {
//        updateCookie(_response);
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      if (responseBody.status_code == 200) {
          List list = responseBody.data;
          writers =
              list.map((model) => ResumeWriteModel.fromJson(model)).toList();
      }else if(responseBody.status_code == 401){
        onTimeOut();
      }else {
        error = 1;
      }
    }else{
      error = 1;
    }
    return writers;
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
              icon: Icon(Icons.arrow_back, color: ColorGlobal.textColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              }
          ),
          title: Text(
            'Write Resume',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: FutureBuilder(
          future: getResumeWriters(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(child: NoInternetScreen());
              case ConnectionState.waiting:
              case ConnectionState.active:
                return Center(
                  child: SpinKitDoubleBounce(
                    color: Colors
                        .lightBlueAccent,
                  ),
                );
              case ConnectionState.done:
                print("done");
                if (snapshot.hasError) {
                  return internet==0 ? Center(child: NoInternetScreen()) : Center(child: Error8Screen());
                } else {
                  print(writers.length);
                  if(error == 1){
                    return Center(child: Error8Screen());
                  }
                  if(writers.length==0){
                    return Center(child: NodataScreen());
                  }
                  return StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    itemCount: writers.length,
                    itemBuilder: (BuildContext context, int index) {
                      print("right here");
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width/25, vertical: width/50),
                        child: Material(
                          color: Colors.white,
                          elevation: 14.0,
                          shadowColor: Color(0x802196F3),
                          borderRadius: BorderRadius.circular(3*width/50),
                          child: Padding
                            (
                            padding: EdgeInsets.all(3*width/50),
                            child: Column(
                              children: [
                                Row
                                  (
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: <Widget>
                                    [
                                      Material
                                        (
                                          color: Color(0xfff4c83f),
                                          borderRadius: BorderRadius.circular(
                                              3*width/50),
                                          child: Center
                                            (
                                              child: Padding
                                                (
                                                padding: EdgeInsets.all(
                                                    width/25),
                                                child: Icon(
                                                  Icons.person,
                                                  size: 7*width/100,
                                                  color: Colors.white,
                                                ),
                                              )
                                          )
                                      ),
                                      SizedBox(
                                        width: width/50,
                                      ),
                                      Container(
                                        width: 63*width/100,
                                        child: Column
                                          (
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: <Widget>
                                          [
                                            AutoSizeText('Name', style: TextStyle(
                                                color: Color(0xfff4c83f),
                                                fontSize: 13.0),
                                            maxLines: 1,
                                            ),
                                            AutoSizeText(writers[index].writer_name,
                                                style: TextStyle(
                                                    color: ColorGlobal.textColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20.0),
                                            maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]
                                ),
                                SizedBox(
                                  height: 3*width/100,
                                ),
                                Row
                                  (
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>
                                  [
                                    Material
                                      (
                                        color: Color(0xcc982ef0),
                                        borderRadius: BorderRadius.circular(
                                            3*width/50),
                                        child: Center
                                          (
                                            child: Padding
                                              (
                                              padding: EdgeInsets.all(
                                                  width/25),
                                              child: Icon(
                                                Icons.phone_android,
                                                size: 7*width/100,
                                                color: Colors.white,
                                              ),
                                            )
                                        )
                                    ),
                                    SizedBox(
                                      width: width/50,
                                    ),
                                    Container(
                                      width: 63*width/100,
                                      child: GestureDetector(
                                        onTap: () {
                                          uri = "tel://" +
                                              writers[index].contact_number;
                                          launch(uri);
                                        },
                                        child: Column(
                                          //mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            AutoSizeText('Contact',
                                                style: TextStyle(
                                                    color:
                                                    Color(0xcc982ef0),
                                                    fontSize: 13.0),
                                            maxLines: 1,
                                            ),
                                            AutoSizeText(writers[index].contact_number,
                                                style: TextStyle(
                                                    color: ColorGlobal
                                                        .textColor,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    fontSize: 20.0),
                                            maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3*width/100,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center,
                                  children: [
                                    Material(
                                      color: Color(0xccff3266),
                                      borderRadius: BorderRadius.circular(
                                          3*width/50),
                                      child: Center
                                        (
                                        child: Padding
                                          (
                                          padding: EdgeInsets.all(
                                              width/25),
                                          child: Icon(
                                            Icons.email,
                                            size: 7*width/100,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/50,
                                    ),
                                    Container(
                                      width: 63*width/100,
                                      child: Column
                                        (
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: <Widget>
                                        [
                                          AutoSizeText('Email', style: TextStyle(
                                              color: Color(0xccff3266),
                                              fontSize: 13.0),
                                          maxLines: 1,
                                          ),
                                          AutoSizeText(writers[index].email,
                                              style: TextStyle(
                                                  color: ColorGlobal
                                                      .textColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20.0),
                                          maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3*width/100,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center,
                                  children: [
                                    Material(
                                      color: Color(0xcc3399fe),
                                      borderRadius: BorderRadius.circular(
                                          3*width/50),
                                      child: Center
                                        (
                                        child: Padding
                                          (
                                          padding: EdgeInsets.all(
                                              width/25),
                                          child: Image(
                                            image: AssetImage('assets/images/discounts.png'),
                                            height: 7*width/100,
                                            width: 7*width/100,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/50,
                                    ),
                                    Container(
                                      width: 63*width/100,
                                      child: Column
                                        (
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: <Widget>
                                        [
                                          AutoSizeText('Discounts', style: TextStyle(
                                              color: Color(0xcc3399fe),
                                              fontSize: 13.0),
                                          maxLines: 1,
                                          ),
                                          AutoSizeText(writers[index].discounts,
                                              style: TextStyle(
                                                  color: ColorGlobal
                                                      .textColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20.0),
                                          maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3*width/100,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center,
                                  children: [
                                    Material(
                                      color: Color(0xcc26cb3c),
                                      borderRadius: BorderRadius.circular(
                                          3*width/50),
                                      child: Center
                                        (
                                        child: Padding
                                          (
                                          padding: EdgeInsets.all(
                                              width/25),
                                          child: Icon(
                                            Icons.link,
                                            size: 7*width/100,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/50,
                                    ),
                                    Container(
                                      width: 63*width/100,
                                      child: Column
                                        (
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: <Widget>
                                        [
                                          AutoSizeText('Link', style: TextStyle(
                                              color: Color(0xcc26cb3c),
                                              fontSize: 13.0),
                                          maxLines: 1,
                                          ),
                                          GestureDetector(
                                            onTap: () =>
                                                launch(writers[index].link.toString()),
                                            child: AutoSizeText(writers[index].link,
                                                style: TextStyle(
                                                    color: ColorGlobal
                                                        .textColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20.0),
                                            maxLines: 1,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                  );
                }
            };
            return Center(child: Text("Try Again!"));
          },
        ),
      ),
    );
  }
}