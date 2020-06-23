import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/Constant/Constant.dart';
import 'package:iosrecal/models/MentorGroupModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MentorGroups extends StatefulWidget {
  @override
  _MentorGroupsState createState() => _MentorGroupsState();
}

class _MentorGroupsState extends State<MentorGroups> {
  var groups = new List<MentorGroupModel>();

  Future<List<MentorGroupModel>> _getGroups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        "https://delta.nitt.edu/recal-uae/api/mentor_group/groups",
        headers: {
          "Accept": "application/json",
          "Cookie": "${prefs.getString("cookie")}",
        }
    );
    if (response.statusCode == 200) {
      print("success");
      ResponseBody responseBody = ResponseBody.fromJson(
          json.decode(response.body));
      if (responseBody.status_code == 200) {
        List list = responseBody.data;
        print(list);
        //groups = list.map((model) => MentorGroupModel.fromJson(model)).toList();
        for(var group in list){
          MentorGroupModel mentorGroupModel = MentorGroupModel(
              mentor_group_id: group["mentor_group_id"],
              industry: group["industry"],
              leader: group["leader"],
              group: group["group"]);
          groups.add(mentorGroupModel);
        }

        print(groups.length);
        return groups;
      } else {
        print(responseBody.data);
      }
    } else {
      print('Server error');
    }
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
            FutureBuilder(
              future: _getGroups(),
              builder: (BuildContext context, AsyncSnapshot projectSnap) {
                //                Whether project = projectSnap.data[index]; //todo check your model
                var childCount = 0;
//                if (projectSnap.connectionState !=
//                    ConnectionState.done || projectSnap.hasData == null)
//                  childCount = 1;
                if (projectSnap.data == null) {
                  return SliverFillRemaining(
                    child: Container(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }
                else {
                  childCount=projectSnap.data.length;
                  print(childCount);
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return new Padding(padding: new EdgeInsets.fromLTRB(
                              16.0, 16.0, 16.0, 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
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
                          );
                        },
                        childCount: childCount),
                  );
                }
              },
            ),

          ],
        ));

  }
}
