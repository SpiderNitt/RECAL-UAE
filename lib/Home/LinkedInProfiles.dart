import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant/ColorGlobal.dart';
import 'package:iosrecal/models/ResponseBody.dart';


int num=0;
class LinkedinModel {
  final int id;
  final String user;
  final String linkedin;

  LinkedinModel({this.id, this.user,  this.linkedin});

  factory LinkedinModel.fromJson(Map<String, dynamic> json) {
    return LinkedinModel(
      id: json['id'],
      
      user: json['user'],
      linkedin: json['linkedin'],
    );
  }
}



class LinkedIn extends StatefulWidget {
  @override
  LinkedinState createState() => LinkedinState();
}

class LinkedinState extends State<LinkedIn> {

  var positions = new List<LinkedinModel>();

  initState() {
    super.initState();
    _positions();
  }

  Future<String> _positions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        "https://delta.nitt.edu/recal-uae/api/employment/linked_profiles",
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
              list.map((model) => LinkedinModel.fromJson(model)).toList();
          for(int i=0;i<positions.length;i++){
            if(positions[i].id!=null){
              num++;
            }
          }
          print("Answer");
          print(positions.length);
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
            'LinkedIn Profiles',
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
                    child: Row(
                      children: <Widget>[
                        Image(
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/linkedinIcon.png'),
                      alignment: Alignment.bottomCenter,
                    ),
                    SizedBox(width: 30,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text( 
                              positions[index].user.toUpperCase() ,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: ColorGlobal.textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            
                            
                            Text(
                              "link",
                              style: TextStyle(
                                fontSize: 15.0,
                                color: ColorGlobal.textColor,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        SizedBox(height: 12.0),
                        
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
