import 'dart:convert';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/routes.dart';
import 'package:iosrecal/models/MemberModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/widgets/NoInternet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iosrecal/widgets/Error.dart';
import 'package:iosrecal/widgets/NoData.dart';
import 'package:iosrecal/constants/Api.dart';
import 'package:connectivity/connectivity.dart';
import 'package:iosrecal/constants/UIUtility.dart';
import 'dart:io' show Platform;

class MemberDatabase extends StatefulWidget {
  @override
  _MemberDatabaseState createState() => _MemberDatabaseState();
}

class _MemberDatabaseState extends State<MemberDatabase> {
  var members = new List<MemberModel>();
  int internet = 1;
  int error = 0;
  UIUtility uiUtills = new UIUtility();

  initState() {
    super.initState();
    uiUtills = new UIUtility();
    //_positions();
  }

  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }

  Future<List> _members() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      internet = 0;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http
        .get(Api.allUsers, headers: {
      "Accept": "application/json",
      "Cookie": "${prefs.getString("cookie")}",
    });
    ResponseBody responseBody = new ResponseBody();
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("success");
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      if (responseBody.status_code == 200) {
        List list = responseBody.data;
        members = list.map((model) => MemberModel.fromJson(model)).toList();
        members.sort((a,b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      }else if(responseBody.status_code == 401){
        onTimeOut();
      }else{
        error = 1;
      }
    }else{
      error = 1;
    }
    return members;
  }

  refresh(){
    setState(() {

    });
    _members();
  }


  Future<bool> onTimeOut(){
    return showDialog(
      barrierDismissible: false,
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
  navigateAndReload(){
    Navigator.pushNamed(context, LOGIN_SCREEN, arguments: true)
        .then((value) {
      Navigator.pop(context);
      setState(() {

      });
      _members();});
  }
  
  bool isEmpty(String linkedin){
    if(linkedin==null || linkedin.trim()=="")
      return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> colorArray = [Colors.blue, Colors.purple, Colors.blueGrey, Colors.deepOrange, Colors.redAccent];
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
            'Social Network List',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: _members(),
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
                      print("members length" + members.length.toString());
                      if(error == 1){
                        return Center(child: Error8Screen());
                      }
                      if(members.length==0){
                        return Center(child: NodataScreen());
                      }
                      return ListView.separated(
                        itemCount: members.length,
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemBuilder: (context, index) {
                          Color color = colorArray.elementAt(Random().nextInt(4));

                          return members[index].name !=null ? ExpansionTile(
                            title: AutoSizeText(members[index].name,
                              style: TextStyle(
                                fontSize: getWidth(18, 2),
                                color: ColorGlobal.textColor,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: color,
                              child: Icon(
                                Icons.person,
                                color: ColorGlobal.whiteColor,
                              ),
                            ),
                            //backgroundColor: Colors.red,
                            children: [
                              members[index].email!=null && members[index].email.trim()!="" ? ListTile(
                                title: CustomToolTip(text: members[index].email,),
                                leading: Icon(Icons.email,  size: getWidth(26,2), color: Colors.indigoAccent),
                              ) : Container(),
                              members[index].organization!=null && members[index].organization.trim()!="" ? ListTile(
                                title: AutoSizeText(members[index].organization, style : TextStyle(fontSize: getWidth(16,2)), maxLines: 1,),
                                leading: Icon(Icons.business, size: getWidth(26,2), color: Colors.orange),
                              ) : Container(),
                              members[index].position!=null && members[index].position.trim()!="" ? ListTile(
                                title: AutoSizeText(members[index].position, style : TextStyle(fontSize: getWidth(16,2)), maxLines: 1,),
                                leading: Icon(Icons.business_center, size: getWidth(26,2), color: Colors.green),
                              ) : Container(),
                              !isEmpty(members[index].linkedIn_link) ? ListTile(
                                title: new GestureDetector(
                                    child: new AutoSizeText(members[index].linkedIn_link, style : TextStyle(fontSize: getWidth(16,2)), maxLines: 1,),
                                    onTap: () =>
                                        launch(members[index].linkedIn_link)
                                ),
                                leading: Image(
                                  image: AssetImage('assets/images/linkedin.png'),
                                  height: getWidth(24, 2),
                                  width: getWidth(24, 2),
                                ),
                              ) : Container(),
                            ],
                          ) : Container();
                        },
                      );
                    }
                }
                return Center(child: Text("Try Again!"
                )
                );
              },
            ),

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
      child: new Tooltip(preferBelow: false,
          message: "Copy", child: AutoSizeText(text, style :TextStyle(fontSize: getWidth(16,2)), maxLines: 1,)),
      onTap: () {
        Fluttertoast.showToast(msg: "Copied Email Address",textColor: Colors.white,backgroundColor: Colors.green);
        Clipboard.setData(new ClipboardData(text: text));
      },
      onDoubleTap: () {
        Fluttertoast.showToast(msg: "Copied Email Address",textColor: Colors.white,backgroundColor: Colors.green);
        Clipboard.setData(new ClipboardData(text: text));
      },
    );
  }
}
