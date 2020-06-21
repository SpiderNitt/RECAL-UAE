import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:url_launcher/url_launcher.dart';

class MentorModel {
  final String body;
  MentorModel({this.body});
  factory  MentorModel.fromJson(Map<String,dynamic> json) {
    return  MentorModel(
      body: json["body"],
    );
  }
}
Future< MentorModel> createRequest(String body ) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final http.Response response = await http.post(
    "https://delta.nitt.edu/recal-uae/api/employment/seek_guidance",
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      "Accept" : "application/json",
      "Cookie" : "${prefs.getString("cookie")}",
    },
    body: jsonEncode(<String, String>{
      'user_id': "${prefs.getString("user_id")}",
      'body': body,
    }),
  );


  if (response.statusCode == 200) {
    Map<String,dynamic> jsonSurvey = json.decode(response.body);
    debugPrint("REQUEST SENT");
    Fluttertoast.showToast(
        msg: "Message sent",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
    return  MentorModel.fromJson(jsonSurvey);

  } else {
    Fluttertoast.showToast(
        msg: "An error occured. Plese try again",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    throw Exception('Failed to send reques');
  }

}

class WriteMentorScreen extends StatefulWidget {
  @override
  WriteMentorScreenState createState() => new WriteMentorScreenState();
}

class WriteMentorScreenState extends State<WriteMentorScreen> {
  Future<bool> _onBackPressed() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final TextEditingController _controller = TextEditingController();

    Future<MentorModel> _futureMentor;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
        appBar: AppBar(
          title: Text('Seek Guidance'),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body:  SingleChildScrollView(
          child:(_futureMentor == null)?Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.fromLTRB(20.0, height / 10, 20, 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          Text(
                            "REQUEST FOR A MENTOR",
                            style: TextStyle(
                                fontSize: 25,
                                color: const Color(0xff3AAFFA),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            "Please write your message in the box below",
                            style: TextStyle(
                              fontSize: 15,
                              color: const Color(0xff3AAFFA),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20.0),
                          TextField(
                            autocorrect: true,
                            maxLines: 5,
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Enter message',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              filled: true,
                              fillColor: Colors.white70,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                                borderSide: BorderSide(
                                    color: Color(0xFF3AAFFA), width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                                borderSide: BorderSide(
                                    color: Color(0xFF3AAFFA), width: 2),
                              ),
                            ),
                          ),
                          SizedBox(height:16.0),
                          RawMaterialButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              setState(() {
                              _futureMentor = createRequest(_controller.text);
                            });},
                            elevation: 2.0,
                            fillColor: Colors.blue,
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            padding: EdgeInsets.all(15.0),
                            shape: CircleBorder(),
                          ),
                          SizedBox(height: 16.0),
                        ],
                      )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Image(
                          height: height / 3,
                          width: width,
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/seek_guidance_bottom.jpg'),
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ],
                  )
                ],
              ))
              :FutureBuilder<MentorModel>(
            future: _futureMentor,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print("Sent");
                return Text(snapshot.data.body);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
