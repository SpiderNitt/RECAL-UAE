import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iosrecal/Home/NoData.dart';
import 'package:iosrecal/Home/errorWrong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/models/MentorGroupModel.dart';
import '../Constant/ColorGlobal.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MentorGroups extends StatefulWidget {
  @override
  _MentorGroupsState createState() => _MentorGroupsState();
}

class _MentorGroupsState extends State<MentorGroups> {
  var groups = new List<MentorGroupModel>();
  int state = 0;
  bool _hasError = false;

  initState() {
    super.initState();
    _groups();
  }
  Future<List> _groups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        "https://delta.nitt.edu/recal-uae/api/mentor_group/groups",
        headers: {
          "Accept": "application/json",
          "Cookie": "${prefs.getString("cookie")}",
        }
    );
    ResponseBody responseBody = new ResponseBody();

    if (response.statusCode == 200) {
      print("success");
//        updateCookie(_response);
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      if (responseBody.status_code == 200) {
        List list = responseBody.data;
        groups =
            list.map((model) => MentorGroupModel.fromJson(model)).toList();
        setState(() {
          state = 1;
        });
      } else {
        setState(() {
          _hasError = true;
        });
      }
    } else {
      _hasError = false;
    }
  }

  Widget getBody(){
    if(_hasError){
      return Center(child: Error8Screen());
    }if(state==0){
      return Center(
        child: SpinKitDoubleBounce(
          color: Colors.lightBlueAccent,
        ),
      );
    }
    if(groups.length == 0){
      return Center(child: NodataScreen());
    }
    return CustomScrollView(
      slivers: <Widget>[
        new SliverAppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: ColorGlobal.textColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              }
          ),
          brightness: Brightness.dark,
          centerTitle: true,
          expandedHeight: 250,
          floating: true,
          pinned: true,
          snap: true,
          elevation: 50,
          flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text('Mentor Groups',
                style: TextStyle(color: ColorGlobal.textColor, fontSize: 20.0),
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
                  (context, index) =>new Padding(padding: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                              groups[index].group,
                              style: new TextStyle(fontSize: 18.0)
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      const Divider(
                        color: const Color(0x22000000),
                        height: 1,
                        thickness: 1,
                      ),
                    ],
                  )
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
