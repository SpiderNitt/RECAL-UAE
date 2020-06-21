import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/models/MentorGroupModel.dart';
import 'package:iosrecal/Constant/Constant.dart';
import './MentorList.dart';

class MentorGroups extends StatefulWidget {
  @override
  _MentorGroupsState createState() => _MentorGroupsState();
}

class _MentorGroupsState extends State<MentorGroups> {
  var groups = new List<MentorGroupModel>();

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
        print(response.body);
      } else {
        print(responseBody.data);
      }
    } else {
      print('Server error');
    }
  }

  List _buildList(int count, BuildContext context) {
    List<Widget> listItems = List();
    List<String> groups = List();
    groups.add("IT and Related Services");
    groups.add("Energy");
    groups.add("Construction");
    groups.add("Banking/Finance/Investment");
    groups.add("Trading/MFG/Recycling");
    groups.add("Education/Others");

    for (int i = 0; i < count; i++) {
      String t = 'textHero' + i.toString();
      listItems.add(new Padding(padding: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Hero(
                    tag : t,
                    child: new Text(
                        groups[i],
                        style: new TextStyle(fontSize: 18.0)
                    ),
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
      );
    }

    return listItems;
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(

        body: new CustomScrollView(
          slivers: <Widget>[
            new SliverAppBar(
              brightness: Brightness.dark,
              centerTitle: true,
              title: Text('Mentor Groups'),
              expandedHeight: 250,
              floating: true,
              pinned: true,
              snap: true,
              elevation: 50,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text('Mentor Groups',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
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
//            FutureBuilder(
//              future: _groups(),
//              builder: (context, projectSnap) {
//                //                Whether project = projectSnap.data[index]; //todo check your model
//                var childCount = 0;
//                if (projectSnap.connectionState !=
//                    ConnectionState.done || projectSnap.hasData == null)
//                  childCount = 1;
////                else
////                  childCount = projectSnap.data.length;
//                return SliverList(
//                  delegate: SliverChildBuilderDelegate(
//                          (context, index) {
//                        if (projectSnap.connectionState !=
//                            ConnectionState.done) { //todo handle state
//                          return CircularProgressIndicator(); //todo set progress bar
//                        }
//                        if (projectSnap.hasData == null) {
//                          return Container();
//                        }
//                        return new Padding(padding: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
//                            child: Column(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: <Widget>[
//                                Row(
//                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                  children: <Widget>[
//                                    new Text(
//                                        groups[index].group,
//                                        style: new TextStyle(fontSize: 18.0)
//                                    ),
//                                    Container(
//                                      height: 30.0,
//                                      width: 30.0,
//                                      child: IconButton(
//                                          icon: Icon(Icons.arrow_forward_ios,
//                                            color: Color(0x88000000),
//                                          ),
//                                          onPressed: () {
//                                            Navigator.pushNamed(context,MENTOR_LIST_SCREEN);
//                                            // Do something
//                                          }
//                                      ),
//                                    ),
//                                  ],
//                                ),
//                                SizedBox(height: 16.0),
//                                const Divider(
//                                  color: const Color(0x22000000),
//                                  height: 1,
//                                  thickness: 1,
//                                ),
//                              ],
//                            )
//                        );
//                      },
//                      childCount: childCount),
//                );
//              },
//            ),
            new SliverList(
                delegate: new SliverChildListDelegate(_buildList(6, context))
            ),
          ],
        ));

  }
}
