import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:page_transition/page_transition.dart';
import '../Constant/ColorGlobal.dart';
import '../Constant/Constant.dart';
import 'SocialMedia.dart';
import 'MarketSurvey.dart';

class SocialPage extends StatefulWidget {
  @override
  _SocialPageState createState() => new _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  Future<bool> _onBackPressed() {
    Navigator.pop(context);
  }

  _getSocialWidget(context) {
    final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Container(
          child: FadeIn(
            child: Image.asset(
              "assets/images/socialBusiness.jpg",
              fit: BoxFit.contain,
              height: height/2 - width/5,
            ),
            duration: Duration(milliseconds: 0),
            curve: Curves.easeInOutBack,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => SocialMediaScreen());
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: width / 5,
                        width: width / 5,
                        child: RaisedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => SocialMediaScreen());
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          padding: EdgeInsets.all(0.0),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => SocialMediaScreen());
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff374ABE),
                                      Color(0xff3AAFFA)
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                width: width / 5,
                                height: width / 5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
//                                    alignment: Alignment.centerRight,
                                      child: Image(
                                        height: width / 5,
                                        width: width / 5,
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            'assets/images/social.png'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
//                                    alignment: Alignment.center,
                        child: AutoSizeText(
                          "Social Media",
                          style: TextStyle(
                              fontSize: 15.0,
                              color: ColorGlobal.textColor,
                              fontWeight: FontWeight.w600),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      height: width / 5,
                      width: width / 5,
                      child: RaisedButton(
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        padding: EdgeInsets.all(0.0),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => SocialMediaScreen());
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff374ABE),
                                    Color(0xff3AAFFA)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              width: width / 5,
                              height: width / 5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
//                                    alignment: Alignment.centerRight,
                                    child: Image(
                                      height: width / 5,
                                      width: width / 5,
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/images/mentor.png'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
//                                    alignment: Alignment.center,
                      child: AutoSizeText(
                        "Write to Mentor",
                        style: TextStyle(
                            fontSize: 15.0,
                            color: ColorGlobal.textColor,
                            fontWeight: FontWeight.w600),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: width / 5,
                      width: width / 5,
                      child: RaisedButton(
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        padding: EdgeInsets.all(0.0),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => SocialMediaScreen());
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff374ABE),
                                    Color(0xff3AAFFA)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              width: width / 5,
                              height: width / 5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
//                                    alignment: Alignment.centerRight,
                                    child: Image(
                                      height: width / 5,
                                      width: width / 5,
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/images/update.png'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
//                                    alignment: Alignment.center,
                      child: AutoSizeText(
                        "Get Update",
                        style: TextStyle(
                            fontSize: 15.0,
                            color: ColorGlobal.textColor,
                            fontWeight: FontWeight.w600),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SurveyScreen()));
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: width / 5,
                        width: width / 5,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SurveyScreen()));
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          padding: EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff374ABE),
                                    Color(0xff3AAFFA)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              width: width / 3,
                              height: width / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
//                                    alignment: Alignment.centerRight,
                                    child: Image(
                                      height: width / 5,
                                      width: width / 5,
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/images/survey.png'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
//                                    alignment: Alignment.center,
                        child: AutoSizeText(
                          "Market Survey",
                          style: TextStyle(
                              fontSize: 15.0,
                              color: ColorGlobal.textColor,
                              fontWeight: FontWeight.w600),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
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
                    title: Text('Social Business',
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
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 40.0,
                  crossAxisSpacing: 40.0,
                  childAspectRatio: 4.0,
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => SocialMediaScreen());
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: width / 5,
                                width: width / 5,
                                child: RaisedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => SocialMediaScreen());
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0)),
                                  padding: EdgeInsets.all(0.0),
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => SocialMediaScreen());
                                    },
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xff374ABE),
                                              Color(0xff3AAFFA)
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Container(
                                        width: width / 5,
                                        height: width / 5,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
//                                    alignment: Alignment.centerRight,
                                              child: Image(
                                                height: width / 5,
                                                width: width / 5,
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                    'assets/images/social.png'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
//                                    alignment: Alignment.center,
                                child: AutoSizeText(
                                  "Social Media",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: ColorGlobal.textColor,
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              height: width / 5,
                              width: width / 5,
                              child: RaisedButton(
                                onPressed: () {},
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                padding: EdgeInsets.all(0.0),
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => SocialMediaScreen());
                                  },
                                  child: Ink(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xff374ABE),
                                            Color(0xff3AAFFA)
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Container(
                                      width: width / 5,
                                      height: width / 5,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
//                                    alignment: Alignment.centerRight,
                                            child: Image(
                                              height: width / 5,
                                              width: width / 5,
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  'assets/images/mentor.png'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
//                                    alignment: Alignment.center,
                              child: AutoSizeText(
                                "Write to Mentor",
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: ColorGlobal.textColor,
                                    fontWeight: FontWeight.w600),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  childCount: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
