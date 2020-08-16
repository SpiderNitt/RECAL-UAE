import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/MemberModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constant/ColorGlobal.dart';

class MemberDatabase extends StatefulWidget {
  @override
  _MemberDatabaseState createState() => _MemberDatabaseState();
}

class _MemberDatabaseState extends State<MemberDatabase> {
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
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.person,
                              color: ColorGlobal.textColor,
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              members[index].name,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: ColorGlobal.textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        Icon(
                          Icons.arrow_forward_ios,
                          color: ColorGlobal.textColor,
                        ),
                        //SizedBox(height: 12.0),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
