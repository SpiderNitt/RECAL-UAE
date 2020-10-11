import 'dart:convert';
import 'dart:io' show Platform;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/routes.dart';
import 'package:iosrecal/models/BusinessMemberModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/widgets/NoInternet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iosrecal/widgets/Error.dart';
import 'package:iosrecal/widgets/NoData.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:iosrecal/constants/Api.dart';
import 'package:connectivity/connectivity.dart';
import 'package:iosrecal/constants/UIUtility.dart';


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
  UIUtility uiUtills = new UIUtility();

  initState() {
    super.initState();
    uiUtills = new UIUtility();
    _members();

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
        final_members.sort((a,b)=> a.name.toLowerCase().compareTo(b.name.toLowerCase()));
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
      state = 0;
      _hasError = false;
      _internet = true;
      _members();
    });
  }

  refresh(){
    print('hello');
    setState(() {

    });
    state = 0;
    _hasError = false;
    _internet = true;
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

  Widget getBody() {
    if(!_internet){
      return Center(child: NoInternetScreen(notifyParent: refresh));
    }
    if(_hasError){
      return Center(child: Error8Screen());
    }
    if (state == 0) {
      return SpinKitDoubleBounce(
        color: ColorGlobal.blueColor,
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
                fontSize: getWidth(18, 2),
              ),
            maxLines: 1,
            ),
          leading: CircleAvatar(
            backgroundColor: ColorGlobal.blueColor,
            child: Icon(
              Icons.person,
              color: ColorGlobal.whiteColor,
              size: getWidth(28, 2),
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
