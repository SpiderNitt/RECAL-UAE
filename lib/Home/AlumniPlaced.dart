import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/models/PositionModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constant/ColorGlobal.dart';


class AlumniPlaced extends StatefulWidget {
  @override
  _AlumniPlacedState createState() => _AlumniPlacedState();
}

class _AlumniPlacedState extends State<AlumniPlaced> {

  var positions = new List<PositionModel>();

  initState() {
    super.initState();
    _placed();
  }

  Future<String> _placed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        "https://delta.nitt.edu/recal-uae/api/employment/alumni_placed",
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
        setState(() {
          List list = responseBody.data;
          positions =
              list.map((model) => PositionModel.fromJson(model)).toList();
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
    String uri;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorGlobal.whiteColor,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: ColorGlobal.textColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              }
          ),
          title: Text(
            'Alumni Placed',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: positions.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              positions[index].position + ", ",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: ColorGlobal.textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              positions[index].company,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: ColorGlobal.textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.0),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                positions[index].description,
                                style: TextStyle(
                                  color: ColorGlobal.textColor,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.call, color: ColorGlobal.color2),
                                SizedBox(width: 4.0),
                                GestureDetector(
                                  onTap: () {
                                    uri = "tel://" + positions[index].contact;
                                    launch(uri);
                                  },
                                  child: Text(positions[index].contact,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: ColorGlobal.textColor,
                                      )),
                                )
                              ],
                            ),
                          ],
                        )
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
