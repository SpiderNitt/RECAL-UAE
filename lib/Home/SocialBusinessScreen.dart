import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:page_transition/page_transition.dart';
import '../Constant/ColorGlobal.dart';
import '../Constant/Constant.dart';
import './SocialMedia.dart';
import './MarketSurvey.dart';
import './Feedback.dart';

class SocialPage extends StatefulWidget {
  @override
  _SocialPageState createState() => new _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  Future<bool> _onBackPressed() {
    Navigator.pop(context); 
  }

  
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
          body:  NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }
            ),
            expandedHeight: 250.0,
            floating: true,
            pinned: true,
            snap: true,
            elevation: 50,
            backgroundColor: const Color(0xFF3AAFFA),
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text('Social/Business Groups',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                background: Hero(
                  tag: 'imageHero',
                  child: Image.asset(
                    "assets/images/socialBusiness.jpg",
                    fit: BoxFit.cover,
                  ),
                )
            ),
          ),
            ];
          },
          body: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
              child: new Column(
                children: <Widget>[
                  
                 
                  SizedBox(height: 10.0),
                  
                  Container(
                    height: 80.0,
                    alignment: Alignment.centerRight,
                    child: RaisedButton(
                      onPressed: (){ Navigator.pushNamed(context, SOCIAL_MEDIA);},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff374ABE), Color(0xff3AAFFA)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth: width , minHeight: 80.0),
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                
                                Container(
//                                    alignment: Alignment.centerRight,
                                  child: Image(
                                    height: 40.0,
                                    width: 40.0,
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage('assets/images/social.png'),
                                    alignment: Alignment.bottomCenter,
                                  ),
                                ),
                                Container(
//                                    alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Social Media",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                
                  
                  SizedBox(height: 10.0),
                  Container(
                    height: 80.0,
                    alignment: Alignment.centerRight,
                    child: RaisedButton(
                      onPressed: () {Navigator.pushNamed(context, FEED_BACK);},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff374ABE), Color(0xff3AAFFA)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth: width , minHeight: 80.0),
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                             
                                Container(
//                                    alignment: Alignment.centerRight,
                                  child: Image(
                                    height: 40.0,
                                    width: 40.0,
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage('assets/images/survey.png'),
                                    alignment: Alignment.bottomCenter,
                                  ),
                                ),
                                   Container(
//                                    alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Feedback",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    height: 80.0,
                    alignment: Alignment.centerRight,
                    child: RaisedButton(
                      onPressed: () {Navigator.pushNamed(context, WRITE_MENTOR);},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff374ABE), Color(0xff3AAFFA)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth: width , minHeight: 80.0),
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                             
                                Container(
//                                    alignment: Alignment.centerRight,
                                  child: Image(
                                    height: 40.0,
                                    width: 40.0,
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage('assets/images/mentor.png'),
                                    alignment: Alignment.bottomCenter,
                                  ),
                                ),
                                   Container(
//                                    alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Write to mentor",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white,fontWeight: FontWeight.bold),
                                  ),
                                ),
                                
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    height: 80.0,
                    alignment: Alignment.centerRight,
                    child: RaisedButton(
                      onPressed: () {Navigator.pushNamed(context, MEMBER_LINKEDIN);},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff374ABE), Color(0xff3AAFFA)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth: width , minHeight: 80.0),
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                             
                                Container(
//                                    alignment: Alignment.centerRight,
                                  child: Image(
                                    height: 40.0,
                                    width: 40.0,
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage('assets/images/linkedin.png'),
                                    alignment: Alignment.bottomCenter,
                                  ),
                                ),
                                   Container(
//                                    alignment: Alignment.centerLeft,
                                  child: Text(
                                    "LinkedIn profiles",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
        )
      )
    );
  }
}
