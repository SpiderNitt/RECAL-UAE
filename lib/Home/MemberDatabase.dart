import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/MemberModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constant/ColorGlobal.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iosrecal/Home/errorWrong.dart';
import 'package:iosrecal/Home/NoData.dart';

class MemberDatabase extends StatefulWidget {
  @override
  _MemberDatabaseState createState() => _MemberDatabaseState();
}

class _MemberDatabaseState extends State<MemberDatabase> {
  var members = new List<MemberModel>();

  initState() {
    super.initState();
    //_positions();
  }

  Future<List> _positions() async {
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
        //setState(() {
          List list = responseBody.data;
          members = list.map((model) => MemberModel.fromJson(model)).toList();
          //print(positions.length);
        //});
      }
    }
    return members;
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
            'Social Network Lists',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: _positions(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(child: Error8Screen());
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return Center(
                      child: SpinKitDoubleBounce(
                        color: Colors.lightBlueAccent,
                      ),
                    );
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(child: Error8Screen());
                    } else {
                      print("members length" + members.length.toString());
                      if(members.length==0){
                        return Center(child: NodataScreen());
                      }
                      return ListView.separated(
                        itemCount: members.length,
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemBuilder: (context, index) {
                int color;
                if(members[index].gender=="male")
                  color = 0xbb3399fe;
                else{
                  color = 0xbbff3266;
                  print("female");
                }
                return members[index].name !=null ? ExpansionTile(
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
                    members[index].email!=null ? ListTile(
                      title: Text(members[index].email),
                      leading: Icon(Icons.email),
                    ) : Container(),
                    ListTile(
                      title: Text(members[index].organization),
                      leading: Icon(Icons.business),
                    ),
                    members[index].position!=null ? ListTile(
                      title: Text(members[index].position),
                      leading: Icon(Icons.business_center),
                    ) : Container(),
                    members[index].linkedIn_link !=null ? ListTile(
                      title: new GestureDetector(
                          child: new Text(members[index].linkedIn_link),
                          onTap: () =>
                              launch(members[index].linkedIn_link)
                      ),
                      leading: Icon(Icons.share),
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
