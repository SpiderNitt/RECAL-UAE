import 'dart:convert';
import 'dart:math';
import 'dart:io' show Platform;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iosrecal/routes.dart';
import 'package:iosrecal/widgets/NoData.dart';
import 'package:iosrecal/widgets/NoInternet.dart';
import 'package:iosrecal/widgets/Error.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/models/MentorGroupModel.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:iosrecal/constants/Api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iosrecal/constants/UIUtility.dart';
import 'package:connectivity/connectivity.dart';

class MentorGroups extends StatefulWidget {
  @override
  _MentorGroupsState createState() => _MentorGroupsState();
}

class _MentorGroupsState extends State<MentorGroups> {
  var groups = new List<MentorGroupModel>();
  int state = 0;
  bool _hasError = false;
  bool _hasInternet = true;
  UIUtility uiUtills = new UIUtility();

  initState() {
    super.initState();
    uiUtills = new UIUtility();
    _groups();
  }

  refresh(){
    setState(() {

    });
    state = 0;
    _hasError = false;
    _hasInternet = true;
    _groups();
  }

  Future<List> _groups() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _hasInternet = false;
      });

      return null;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        Api.mentorGroups,
        headers: {
          "Accept": "application/json",
          "Cookie": "${prefs.getString("cookie")}",
        }
    );
    ResponseBody responseBody = new ResponseBody();

    if (response.statusCode == 200) {
      print("success");
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      if (responseBody.status_code == 200) {
        List list = responseBody.data;
        groups =
            list.map((model) => MentorGroupModel.fromJson(model)).toList();
        setState(() {
          state = 1;
        });
      }else if(responseBody.status_code==401){
        onTimeOut();
      } else {
        setState(() {
          _hasError = true;
        });
      }
    } else {
      _hasError = false;
    }
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
      state = 0;
      _hasError = false;
      _hasInternet = true;
      _groups();});
  }

  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }

  Widget getBody(){
    if(_hasInternet== false){
      return Center(child: NoInternetScreen(notifyParent: refresh));
    }
    if(_hasError){
      return Center(child: Error8Screen());
    }if(state==0){
      return Center(
        child: SpinKitDoubleBounce(
          color: ColorGlobal.blueColor,
        ),
      );
    }
    if(groups.length == 0){
      return Center(child: NodataScreen());
    }
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    uiUtills.updateScreenDimesion(width: width,height: height);
    final List<Color> colorArray = [Colors.blue, Colors.purple, Colors.blueGrey, Colors.deepOrange, Colors.redAccent];
    return CustomScrollView(
      slivers: <Widget>[
        new SliverAppBar(
          leading: IconButton(
              icon: Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios, color: ColorGlobal.textColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              }
          ),
          brightness: Brightness.dark,
          centerTitle: true,
          expandedHeight: getHeight(250, 2),
          floating: true,
          pinned: true,
          snap: true,
          elevation: 50,
          backgroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text('Mentor Groups',
                style: TextStyle(color: ColorGlobal.textColor, fontSize: getHeight(20, 2)),
              ),
              background: Hero(
                tag: 'imageHero',
                child: Image.asset(
                  "assets/images/mentor_groups.jpg",
                  fit: BoxFit.cover,
                ),
              )
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
                  (context, index) =>GestureDetector(
                    onTap: () => Navigator.pushNamed(context, WRITE_MENTOR),
                    child: Container(
                        height: height / 8,
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          child: Card(
                            //color: ColorGlobal.blueColor,
                            elevation: 2,
                            margin: const EdgeInsets.all(4),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: width / 18,
                                  ),
                                  CircleAvatar(
                                    radius: width/14,
                                    backgroundColor: colorArray.elementAt(Random().nextInt(4)),
                                    child: Text(groups[index].group.toUpperCase()[0],style: TextStyle(fontSize: width/14, color: ColorGlobal.whiteColor),),
                                  ),
                                  SizedBox(
                                    width: width / 32,
                                  ),
                                  Container(
                                    height: width/12,
                                    width: 1.0,
                                    color: Colors.grey[200],
                                  ),
                                  SizedBox(
                                    width: width / 32,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: width - ( 13 + width/18 + width/7 + width/16),
                                        color: Colors.transparent,
                                        child: AutoSizeText(
                                          groups[index].group,
                                          style: TextStyle(
                                            fontSize: getHeight(22, 2),
                                            color: ColorGlobal.textColor,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: width - ( 13 + width/18 + width/7 + width/16),
                                        child: AutoSizeText(
                                          groups[index].leader,
                                          style: TextStyle(
                                            fontSize: getHeight(19, 2),
                                            color: ColorGlobal.textColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ),
              childCount: groups.length),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

        body: getBody(),
    );

  }
}
