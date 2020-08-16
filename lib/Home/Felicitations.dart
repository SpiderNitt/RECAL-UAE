import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/MemberModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constant/ColorGlobal.dart';

class FelicitationsScreen extends StatefulWidget {
  @override
  _FelicitationsScreenState createState() => _FelicitationsScreenState();
}

class _FelicitationsScreenState extends State<FelicitationsScreen> {

  var members = new List<MemberModel>();

  initState() {
    super.initState();
    _positions();
  }

  Future<String> _positions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http
        .get("https://delta.nitt.edu/recal-uae/api/users/all_users/", headers: {
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
          members = list.map((model) => MemberModel.fromJson(model)).toList();
          print("Answer");
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
    return Container();
  }
}

