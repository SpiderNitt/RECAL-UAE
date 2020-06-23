import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

import 'package:http/http.dart' as http;
import 'package:iosrecal/models/ChapterModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant/ColorGlobal.dart';
import 'dart:convert';


class VisionMission extends StatefulWidget {
  @override
  _VisionMissionState createState() => _VisionMissionState();
}

class _VisionMissionState extends State<VisionMission> {

  String vision;
  String mission;

  initState() {
    super.initState();
    _chapter();
  }

  Future<ChapterModel> _chapter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        "https://delta.nitt.edu/recal-uae/api/chapter/",
        headers: {
          "Accept": "application/json",
          "Cookie": "${prefs.getString("cookie")}",
        }
    );
    if (response.statusCode == 200) {
      Map<String,dynamic> jsonChapter = jsonDecode(response.body);
        return ChapterModel.fromJson(jsonChapter);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: ColorGlobal.whiteColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: ColorGlobal.textColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'Vision and Mission',
                style: TextStyle(color: ColorGlobal.textColor),
              ),
            ),
            body: Center(
              child: FractionallySizedBox(
                  widthFactor: 0.9,
                  heightFactor: 0.8,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                        colors: [
                          Color(0xFFDAD8D9),
                          Color(0xFFD9C8C0).withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFEAE3E3),
                          spreadRadius: 2,
                          blurRadius: 0,
                          // changes position of shadow
                        ),
                      ],
                      border: Border.all(
                        width: 2,
                        color: Color(0xFF544F50), //                   <--- border width here
                      ),
                      color: Color(0xFF544F50),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          (22.0),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                        Image.asset('assets/images/Vision.png'),
                          FadeIn(
                            child: Text(
                              "VISION",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            // Optional paramaters
                            duration: Duration(milliseconds: 2000),
                            curve: Curves.easeIn,
                          ),
                          FadeIn(
                            child:
                            FutureBuilder<ChapterModel>(
                              future: _chapter(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if(snapshot.data.vision!=null){
                                    return  Text(
                                      snapshot.data.vision,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: ColorGlobal.textColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    );
                                  }
                                  else{
                                    return Text("NO DATA AVAILABLE",  style: TextStyle(
                                        fontSize: 20,
                                        color: const Color(0xff3AAFFA),
                                        fontWeight: FontWeight.bold),);
                                  }
                                } else if (snapshot.hasError) {
                                  return Text("Error loading data, Please try again");
                                }
                                // By default, show a loading spinner.
                                return CircularProgressIndicator();
                              },
                            ),
                            duration: Duration(milliseconds: 2000),
                            curve: Curves.easeIn,
                          ),
                        Image.asset('assets/images/mission.png'),
                          FadeIn(
                            child: Text(
                              "MISSION",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            // Optional paramaters
                            duration: Duration(milliseconds: 2000),
                            curve: Curves.easeIn,
                          ),
                          FadeIn(
                            child: FutureBuilder<ChapterModel>(
                              future: _chapter(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if(snapshot.data.vision!=null){
                                    return  Text(
                                      snapshot.data.mission,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: ColorGlobal.textColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    );
                                  }
                                  else{
                                    return Text("NO DATA AVAILABLE",  style: TextStyle(
                                        fontSize: 20,
                                        color: const Color(0xff3AAFFA),
                                        fontWeight: FontWeight.bold),);
                                  }
                                } else if (snapshot.hasError) {
                                  return Text("Error loading data, Please try again");
                                }
                                // By default, show a loading spinner.
                                return CircularProgressIndicator();
                              },
                            ),
                            // Optional paramaters
                            duration: Duration(milliseconds: 2000),
                            curve: Curves.easeIn,
                          ),
                        ],
                      ),
                    ),
                  ),
              ),
            ),
        ),
      ),
    );
  }
}
