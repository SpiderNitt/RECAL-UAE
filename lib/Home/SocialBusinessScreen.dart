import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Constant/Constant.dart';
import '../Constant/ColorGlobal.dart';

class SocialPage extends StatefulWidget {
  @override
  _SocialPageState createState() => new _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  Future<bool> _onBackPressed() {
    Navigator.pop(context);
  }

  void _navigatePage(int i){
    if(i==3)
      Navigator.pushNamed(context, MEMBER_DATABASE);
  }

  List _buildList(int count, BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    List<Widget> listItems = List();
    List<String> groups = List();
    List<AssetImage> images = List();
    groups.add("Business Dashboard");
    groups.add("Past Events");
    groups.add("Felicitations");
    groups.add("Member Database");

    images.add(AssetImage('assets/images/businessDashboard.png'));
    images.add(AssetImage('assets/images/pastEvent.png'));
    images.add(AssetImage('assets/images/felicitation.png'));
    images.add(AssetImage('assets/images/database.png'));

    for (int i = 0; i < count; i++) {
      listItems.add(Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 0),
        child: Container(
          height: 80.0,
          alignment: Alignment.centerRight,
          child: RaisedButton(
            onPressed: (){ _navigatePage(i);},
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
                        child: Image(
                          height: 40.0,
                          width: 40.0,
                          fit: BoxFit.cover,
                          image:
                          images[i],
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                      Container(
                        child: Text(
                          groups[i],
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
      ),
      );
    }

    return listItems;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: SafeArea(
            child: Scaffold(
              body:  CustomScrollView(
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
                            title: Text('Social/Business Groups',
                              style: TextStyle(color: ColorGlobal.textColor, fontSize: 20.0),
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
                      new SliverList(
                          delegate: new SliverChildListDelegate(_buildList(4, context))
                      ),
                    ],
                  ),
            )
        )
    );
  }
}