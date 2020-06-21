import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iosrecal/models/ResumeWriteModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/ResponseBody.dart';


class WriteResume extends StatefulWidget {
  @override
  _WriteResumeState createState() => _WriteResumeState();
}

class _WriteResumeState extends State<WriteResume> {
  var writers = new List<ResumeWriteModel>();

  initState() {
    super.initState();
    getResumeWriters();
  }

  Future<String> getResumeWriters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        "https://delta.nitt.edu/recal-uae/api/employment/write_resume",
        headers: {
          "Accept": "application/json",
          "Cookie": "${prefs.getString("cookie")}",
        }
    );
    ResponseBody responseBody = new ResponseBody();

    if (response.statusCode == 200) {
//        updateCookie(_response);
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      if (responseBody.status_code == 200) {
        setState(() {
          List list = responseBody.data;
          writers =
              list.map((model) => ResumeWriteModel.fromJson(model)).toList();
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
            title: Text('Write Resume'),
            backgroundColor: const Color(0xFF3AAFFA),

          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 24.0, 12.0, 24.0),
            child: ListView.builder(
              itemCount: writers.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(writers[index].writer_name));
              },
            ),
          ),
      ),
    );
  }
}
