import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/MemberModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
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
                int color;
                if(members[index].gender=="male")
                  color = 0xbb3399fe;
                else{
                  color = 0xbbff3266;
                  print("female");
                }
                return ExpansionTile(
                  title: Text(members[index].name,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: ColorGlobal.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Color(color),
                    child: Icon(
                      Icons.person,
                      color: ColorGlobal.whiteColor,
                    ),
                  ),
                  //backgroundColor: Colors.red,
                  children: [
                    ListTile(
                      title: Text(members[index].email),
                      leading: Icon(Icons.email),
                    ),
//                    Padding(
//                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                      child: Divider(
//                        thickness: 1,
//                        color: Colors.black12,
//                      ),
//                    ),
                    ListTile(
                      title: Text(members[index].organization),
                      leading: Icon(Icons.business),
                    ),
                    ListTile(
                      title: Text(members[index].position),
                      leading: Icon(Icons.business_center),
                    ),
                    ListTile(
                      title: new InkWell(
                          child: new Text(members[index].linkedIn_link),
                          onTap: () => launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html')
                      ),
                      leading: Icon(Icons.share),
                    ),
                  ],
                );
//                return Card(
//                  child: Padding(
//                    padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Row(
//                          children: <Widget>[
//                            CircleAvatar(
//                              child: Icon(
//                                Icons.person,
//                                color: ColorGlobal.whiteColor,
//                              ),
//                            ),
//                            SizedBox(
//                              width: 15,
//                            ),
////                            VerticalDivider(
////                              color: Colors.red,
////                              thickness: 5,
////                            ),
//                          Container(
//                            height: 24.0,
//                            width: 1.0,
//                            color: Colors.black12,
//                          ),
//                            SizedBox(
//                              width: 15,
//                            ),
//                            Text(
//                              members[index].name,
//                              style: TextStyle(
//                                fontSize: 18.0,
//                                color: ColorGlobal.textColor,
//                                fontWeight: FontWeight.bold,
//                              ),
//                            ),
//                          ],
//                        ),
//
//                        Icon(
//                          Icons.arrow_forward_ios,
//                          color: ColorGlobal.textColor,
//                        ),
//                        //SizedBox(height: 12.0),
//                      ],
//                    ),
//                  ),
//                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
