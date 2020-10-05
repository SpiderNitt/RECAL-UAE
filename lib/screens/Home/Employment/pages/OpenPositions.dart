import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/routes.dart';
import 'package:iosrecal/models/PositionModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/widgets/NoInternet.dart';
import 'package:iosrecal/screens/Home/Employment/pages/JobDetails.dart';
import 'package:iosrecal/widgets/Error.dart';
import 'package:iosrecal/widgets/NoData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:iosrecal/constants/Api.dart';
import 'package:connectivity/connectivity.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:iosrecal/constants/UIUtility.dart';


class OpenPositions extends StatefulWidget {
  @override
  _OpenPositionsState createState() => _OpenPositionsState();
}

class _OpenPositionsState extends State<OpenPositions> {
  var positions = new List<PositionModel>();
  var openPositions = new List<PositionModel>();
  int internet = 1;
  int error = 0;
  UIUtility uiUtills = new UIUtility();

  initState() {
    super.initState();
    uiUtills = new UIUtility();
  }

  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }

  Future<List> _positions() async {
    openPositions = new List<PositionModel>();
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
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      if (responseBody.status_code == 200) {
        List list = responseBody.data;
        positions = list.map((model) => PositionModel.fromJson(model)).toList();

        positions.forEach((element) {
          print(element.company);
          if(element.open_until!=null) {
            if (!DateTime.now().isAfter(DateTime.parse(element.open_until))) {
              openPositions.add(element);
            }
          }
        });

      } else if(responseBody.status_code==401){
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

  refresh(){
    setState(() {

    });
    _positions;
  }

  Future<bool> onTimeOut(){
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('Session Timeout'),
        content : Text('Login in continue'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => navigateAndReload(),
            child: Text("OK"),
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
    final double height = MediaQuery.of(context).size.height;
    uiUtills.updateScreenDimesion(width: width, height: height);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorGlobal.whiteColor,
          leading: IconButton(
              icon: Icon(
                Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
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
                  return Center(child: NoInternetScreen(notifyParent: refresh));
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return Center(
                    child: SpinKitDoubleBounce(
                      color: ColorGlobal.blueColor,
                    ),
                  );
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return internet == 1 ? Center(child: Error8Screen()) : Center(child: NoInternetScreen(notifyParent: refresh));
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
                        return GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute( builder: (context) => JobDetail(openPositions[index]))),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width/25, vertical: width/50),
                            child: Material(
                              color: Colors.white,
                              elevation: 5,
                              borderRadius: BorderRadius.circular(3*width/50),
                              child: Padding(
                                padding: EdgeInsets.all(3*width/50),
                                child: Column(
                                  children: [
//                                    openPositions[index].open_until!=null?
//                                    Row(
//                                      mainAxisAlignment: MainAxisAlignment.end,
//                                      children: [
//                                        AutoSizeText("Open Until: ${openPositions[index].open_until}",
//                                          style: TextStyle(
//                                              color: Colors.red,
//                                              fontSize: getWidth(13, 2)),
//                                          maxLines: 1,
//                                        ),
//                                      ],
//                                    ): SizedBox(),
                                    Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.business_center,
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
                                              AutoSizeText('Position',
                                                style: TextStyle(
                                                    color: Color(0xcc982ef0),
                                                    fontSize: getWidth(13, 2)),
                                                maxLines: 1,
                                              ),
                                              AutoSizeText(openPositions[index].position,
                                                style: TextStyle(
                                                    color:
                                                    ColorGlobal.textColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: getWidth(20, 2)),
                                                maxLines: 3,
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                                    fontSize: getHeight(13, 2)),
                                                maxLines: 1,
                                              ),
                                              AutoSizeText(openPositions[index].company,
                                                style: TextStyle(
                                                    color: ColorGlobal.textColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: getHeight(20, 2)),
                                                maxLines: 3,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
//                                    SizedBox(
//                                      height: 3*width/50,
//                                    ),
//                                    Row(
//                                      crossAxisAlignment:
//                                      CrossAxisAlignment.start,
//                                      children: [
//                                        Icon(
//                                          Icons.description,
//                                          size: width/10,
//                                          color: Color(0xcc982ef0),
//                                        ),
//                                        SizedBox(
//                                          width: 3*width/100,
//                                        ),
//                                        Container(
//                                          width: 67*width/100,
//                                          child: Column(
//                                            mainAxisAlignment:
//                                            MainAxisAlignment.center,
//                                            crossAxisAlignment:
//                                            CrossAxisAlignment.start,
//                                            children: <Widget>[
//                                              AutoSizeText('Description',
//                                                style: TextStyle(
//                                                    color: Color(0xcc982ef0),
//                                                    fontSize: getHeight(13, 2)),
//                                                maxLines: 1,
//                                              ),
//                                              AutoSizeText(openPositions[index].description,
//                                                overflow: TextOverflow.ellipsis,
//                                                style: TextStyle(
//                                                    color: ColorGlobal.textColor,
//                                                    fontWeight: FontWeight.w500,
//                                                    fontSize: getHeight(20, 2)),
//                                                maxLines: 7,
//                                              )
//                                            ],
//                                          ),
//                                        ),
//                                      ],
//                                    ),
                                    SizedBox(
                                      height: 3*width/50,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          size: width/10,
                                          color: Color(0xcc26cb3c),
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
                                              AutoSizeText('Contact',
                                                style: TextStyle(
                                                    color: Color(0xcc26cb3c),
                                                    fontSize: getHeight(13, 2)),
                                                maxLines: 1,
                                              ),
                                              CustomToolTip(text: openPositions[index].contact,),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
              }
              return Center(child: Text("Try Again!"));
            },
          ),
        ),
      ),
    );
  }
}
class CustomToolTip extends StatelessWidget {

  String text;
  UIUtility uiUtills = new UIUtility();

  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }
  CustomToolTip({this.text});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    uiUtills.updateScreenDimesion(width: width, height: height);
    return new GestureDetector(
      child: AutoSizeText(text,
        style: TextStyle(
            color: ColorGlobal.textColor,
            fontWeight: FontWeight.w500,
            fontSize: getHeight(20, 2)),
        maxLines: 2,
      ),
      onTap: () {
        Fluttertoast.showToast(msg: "Copied Contact Details",textColor: Colors.white,backgroundColor: Colors.green);
        Clipboard.setData(new ClipboardData(text: text));
      },
      onDoubleTap: () {
        Fluttertoast.showToast(msg: "Copied Contact Details",textColor: Colors.white,backgroundColor: Colors.green);
        Clipboard.setData(new ClipboardData(text: text));
      },
    );
  }
}
