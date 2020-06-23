import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:url_launcher/url_launcher.dart';

class FeedbackModel {

  final String body;
  FeedbackModel({ this.body});
  factory FeedbackModel.fromJson(Map<String,dynamic> json) {
    return FeedbackModel(
        body: json["body"],
    );
}
}
Future<FeedbackModel> createFeedback(String body ) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.post(
      "https://delta.nitt.edu/recal-uae/api/feedback/send",
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          "Accept" : "application/json",
          "Cookie" : "${prefs.getString("cookie")}",
          "user_id": "${prefs.getString("user_id")}"
        },
         body: jsonEncode(<String, String>{
      'user_id': "${prefs.getString("user_id")}",
      'body': body,
    }),
    );
 

  if (response.statusCode == 200) {
    Map<String,dynamic> jsonSurvey = json.decode(response.body);
    debugPrint("FEEDBACK SENT");
    return FeedbackModel.fromJson(jsonSurvey);

  } else {
    throw Exception('Failed to send feedback');
  }
 
}



class FeedbackScreen extends StatefulWidget {
  @override
  FeedbackScreenState createState() => new FeedbackScreenState();
}

class FeedbackScreenState extends State<FeedbackScreen> {
  Future<bool> _onBackPressed() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final TextEditingController _controller = TextEditingController();
    final String user_id="1";
    Future<FeedbackModel> _futureFeedback;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: new Scaffold(
          appBar: AppBar(
            title: Text('Feedback'),
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
            child: (_futureFeedback == null)?Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.fromLTRB(20.0, height / 30, 20, 0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[

                            Text(
                              "Your feedback matters!!",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: const Color(0xff3AAFFA),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20.0),
                            Text(
                              "Please write your feedback in the box below",
                              style: TextStyle(
                                fontSize: 15,
                                color: const Color(0xff3AAFFA),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20.0),
                            TextField(
                              autocorrect: true,
                              maxLines: 4,
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: 'Enter feedback',
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
                            RawMaterialButton(
                              onPressed: () {setState(() {
                            _futureFeedback = createFeedback(_controller.text);
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
                            )

                          ],
                        )),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Image(
                        height: height / 2,
                        width: width,
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/feed.jpg'),
                        alignment: Alignment.bottomCenter,
                      ),
                    )
                  ],
                ))
                :FutureBuilder<FeedbackModel>(
                    future: _futureFeedback,
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
      ),
    );
  }
}
