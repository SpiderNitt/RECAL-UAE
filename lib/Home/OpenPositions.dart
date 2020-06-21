import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/models/PositionModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constant/ColorGlobal.dart';

class OpenPositions extends StatefulWidget {
  @override
  _OpenPositionsState createState() => _OpenPositionsState();
}

class _OpenPositionsState extends State<OpenPositions> {

  var positions = new List<PositionModel>();

  initState() {
    super.initState();
    _positions();
  }

  Future<String> _positions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        "https://delta.nitt.edu/recal-uae/api/employment/positions",
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
          title: Text('Open Positions'),
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
                          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                positions[index].description,
                                textAlign: TextAlign.left,
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
