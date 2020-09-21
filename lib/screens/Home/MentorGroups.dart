import 'dart:convert';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iosrecal/Constant/Constant.dart';
import 'package:iosrecal/screens/Home/NoData.dart';
import 'package:iosrecal/screens/Home/errorWrong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/models/MentorGroupModel.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:iosrecal/Endpoint/Api.dart';
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
        Api.mentorGroups,
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
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final List<Color> colorArray = [Colors.blue, Colors.purple, Colors.blueGrey, Colors.deepOrange, Colors.redAccent];
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
          backgroundColor: Colors.white,
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
                  (context, index) =>GestureDetector(
                    onTap: () => Navigator.pushNamed(context, WRITE_MENTOR),
                    child: Container(
                        height: height / 8,
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          child: Card(
                            //color: ColorGlobal.blueColor,
                            elevation: 2,
                            margin: const EdgeInsets.all(4),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: width / 18,
                                  ),
                                  CircleAvatar(
                                    radius: width/14,
                                    backgroundColor: colorArray.elementAt(Random().nextInt(4)),
                                    child: Text(groups[index].group.toUpperCase()[0],style: TextStyle(fontSize: width/14, color: ColorGlobal.whiteColor),),
                                  ),
                                  SizedBox(
                                    width: width / 32,
                                  ),
                                  Container(
                                    height: width/12,
                                    width: 1.0,
                                    color: Colors.grey[200],
                                  ),
                                  SizedBox(
                                    width: width / 32,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      AutoSizeText(
                                        groups[index].group,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: ColorGlobal.textColor,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                            groups[index].leader,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: ColorGlobal.textColor,
//                                          fontWeight: FontWeight.bold,
//                                          fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
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
