import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/Constant/Constant.dart';
import 'package:iosrecal/models/BusinessMemberModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/screens/Home/NoInternet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iosrecal/screens/Home/errorWrong.dart';
import 'package:iosrecal/screens/Home/NoData.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:iosrecal/Endpoint/Api.dart';
import 'package:connectivity/connectivity.dart';


class BusinessDatabase extends StatefulWidget {
  @override
  _BusinessDatabaseState createState() => _BusinessDatabaseState();
}

class _BusinessDatabaseState extends State<BusinessDatabase> {
  var members = new List<BusinessMemberModel>();
  var final_members = new List<BusinessMemberModel>();
  var state = 0;
  bool _hasError = false;
  bool _internet = true;

  initState() {
    super.initState();
    _members();
  }

  Future<List> _members() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _internet = false;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http
        .get(
        Api.businessMembers, headers: {
      "Accept": "application/json",
      "Cookie": "${prefs.getString("cookie")}",
    });
    ResponseBody responseBody = new ResponseBody();
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("success");
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      print(responseBody.status_code);
      if (responseBody.status_code == 200) {
        List list = responseBody.data;
        members = list.map((model) => BusinessMemberModel.fromJson(model)).toList();
        List names = List<String>();
        members.forEach((element) {
          if(!names.contains(element.name)){
            final_members.add(element);
            names.add(element.name);
          }

        });

        setState(() {
          state = 1;
        });
      }else if(responseBody.status_code==401){
        onTimeOut();
      }else{
        setState(() {
          _hasError = true;
        });
      }
      //return members;
    }else{
      setState(() {
        _hasError = true;
      });
    }
  }

  navigateAndReload(){
    Navigator.pushNamed(context, LOGIN_SCREEN, arguments: true)
        .then((value) {
      Navigator.pop(context);
      setState(() {

      });
      _members();
    });
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

  Widget getBody() {
    if(!_internet){
      return Center(child: NoInternetScreen());
    }
    if(_hasError){
      return Center(child: Error8Screen());
    }
    if (state == 0) {
      return SpinKitDoubleBounce(
        color: Colors.lightBlueAccent,
      );
    } else if (state == 1 && members.length == 0) {
      return Center(child: NodataScreen());
    }
    return ListView.separated(
      itemCount: final_members.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: AutoSizeText(
            final_members[index].name,
              style: TextStyle(
                color: ColorGlobal.textColor,
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
              ),
            maxLines: 1,
            ),
          leading: CircleAvatar(
            backgroundColor: ColorGlobal.blueColor,
            child: Icon(
              Icons.person,
              color: ColorGlobal.whiteColor,
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }


  @override
  Widget build(BuildContext context) {
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
            'Business Network List',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: getBody(),
            ),
          ),
        ),
    );
  }
}
