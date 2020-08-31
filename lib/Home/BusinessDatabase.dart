import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/BusinessMemberModel.dart';
import 'package:iosrecal/models/MemberModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constant/ColorGlobal.dart';

class BusinessDatabase extends StatefulWidget {
  @override
  _BusinessDatabaseState createState() => _BusinessDatabaseState();
}

class _BusinessDatabaseState extends State<BusinessDatabase> {
  var members = new List<BusinessMemberModel>();

  initState() {
    super.initState();
    _positions();
  }

  Future<String> _positions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http
        .get("https://delta.nitt.edu/recal-uae/api/business/members/", headers: {
      "Accept": "application/json",
      "Cookie": "${prefs.getString("cookie")}",
    });
    ResponseBody responseBody = new ResponseBody();
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("success");
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      if (responseBody.status_code == 200) {
        setState(() {
          List list = responseBody.data;
          members = list.map((model) => BusinessMemberModel.fromJson(model)).toList();
          //print(positions.length);
        });
      } else {
        print(responseBody.data);
      }
    } else {
      print('Server error');
    }
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
            'Member Database',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemCount: members.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(members[index].name,
                  style: TextStyle(
                    color: ColorGlobal.textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                  ),),
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
            ),
          ),
        ),
      ),
    );
  }
}
