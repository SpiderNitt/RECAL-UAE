import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/models/MentorGroupModel.dart';
import '../Constant/ColorGlobal.dart';

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
    groups.add("Energy (Oil and Gas)");
    groups.add("Construction");
    groups.add("Banking/Finance/Investment");
    groups.add("Trading/MFG/Recycling");
    groups.add("Education");
    groups.add("Others");

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

            new SliverList(
                delegate: new SliverChildListDelegate(_buildList(7, context))
            ),
          ],
        ));

  }
}
