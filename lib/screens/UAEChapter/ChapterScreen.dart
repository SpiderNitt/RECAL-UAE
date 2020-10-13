
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/screens/UAEChapter/pages/AchievementsScreen.dart';
import 'package:page_transition/page_transition.dart';
import 'pages/ContactUs.dart';
import 'pages/Pay.dart';
import 'pages/VisionandMission.dart';
import 'pages/CoreComm.dart';
import 'package:iosrecal/constants/UIUtility.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';

class ChapterScreen extends StatefulWidget {
  const ChapterScreen({Key key}) : super(key: key);

  @override
  _ChapterScreenState createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  UIUtility uiUtills = new UIUtility();

  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    uiUtills.updateScreenDimesion(width: width, height: height);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorGlobal.whiteColor,
        appBar: AppBar(
          backgroundColor: ColorGlobal.whiteColor,
          centerTitle: true,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'UAE CHAPTER',
                style: GoogleFonts.josefinSans(color: ColorGlobal.textColor, fontWeight: FontWeight.bold,fontSize: getWidth(20, 1)),
              ),
            ],
          ),
        ),

        body: Column(
          children: <Widget>[
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: getHeight(15, 2)),
                    width: width*0.7,
                    height: width*0.3,
                    padding: EdgeInsets.symmetric(horizontal: getWidth(20,2)),
                    decoration: new BoxDecoration(
                      color: ColorGlobal.colorPrimaryDark,
                      image: new DecorationImage(
                        image: new AssetImage('assets/images/recal_logo.jpg'),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(width*0.1)
                      ),
                  ),
      ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(getHeight(10,2)),
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(10, 2)),
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.downToUp,
                              duration: Duration(milliseconds: 300),
                              child: VisionMission()),);
                      },
                      child: Container(
                        width: width,
                        color: Colors.transparent,
                        child: Row
                          (
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment
                                .center,
                            children: <Widget>
                            [
                              Material
                                (
                                  color: Color(0xfff4c83f),
                                  borderRadius: BorderRadius.circular(
                                      getWidth(24, 2)),
                                  child: Center
                                    (
                                      child: Padding
                                        (
                                        padding: EdgeInsets.all(
                                            getWidth(16, 2)),
                                        child: Icon(
                                          Icons.list,
                                          size: getWidth(30, 2),
                                          color: Colors.white,
                                        ),
                                      )
                                  )
                              ),
                              SizedBox(
                                width: getWidth(8, 2),
                              ),
                              Text('Vision and Mission',
                                  style: TextStyle(
                                      color: ColorGlobal
                                          .textColor,
                                      fontWeight:
                                      FontWeight.w500,
                                      fontSize: getWidth(20, 2))),
                            ]
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getHeight(24, 2),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.leftToRight,
                              duration: Duration(milliseconds: 300),
                              child: CoreComm()),);
                      },
                      child: Container(
                        width: width,
                        color: Colors.transparent,
                        //color: Colors.red,
                        child: Row
                          (
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>
                          [
                            Material
                              (
                                color: Color(0xcc982ef0),
                                borderRadius: BorderRadius.circular(
                                    getHeight(24, 2)),
                                child: Center
                                  (
                                    child: Padding
                                      (
                                      padding: EdgeInsets.all(
                                          getWidth(16, 2)),
                                      child: Icon(
                                        Icons.person,
                                        size: getWidth(30, 2),
                                        color: Colors.white,
                                      ),
                                    )
                                )
                            ),
                            SizedBox(
                              width: getWidth(8, 2),
                            ),
                            Text('Core Committee',
                                style: TextStyle(
                                    color: ColorGlobal
                                        .textColor,
                                    fontWeight:
                                    FontWeight.w500,
                                    fontSize: getWidth(20, 2))),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getHeight(24, 2),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.leftToRight,
                              duration: Duration(milliseconds: 300),
                              child: AchievementsScreen()),);
                      },
                      child: Container(
                        width: width,
                        color: Colors.transparent,
                        //color: Colors.red,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment
                              .center,
                          children: [
                            Material(
                              color: Color(0xcc26cb3c),
                              borderRadius: BorderRadius.circular(
                                  getHeight(24, 2)),
                              child: Center
                                (
                                child: Padding
                                  (
                                  padding: EdgeInsets.all(
                                      getWidth(16, 2)),
                                  child: Icon(
                                    Icons.brightness_low,
                                    size: getWidth(30, 2),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: getWidth(8, 2),
                            ),
                            Text('Achievements',
                                style: TextStyle(
                                    color: ColorGlobal
                                        .textColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: getWidth(20, 2))),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getHeight(24, 2),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 300),
                              child: PayPage()),);
                      },
                      child: Container(
                        width: width,
                        color: Colors.transparent,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment
                              .center,
                          children: [
                            Material(
                              color: Color(0xccff3266),
                              borderRadius: BorderRadius.circular(
                                  getHeight(24, 2)),
                              child: Center
                                (
                                child: Padding
                                  (
                                  padding: EdgeInsets.all(
                                      getWidth(16, 2)),
                                  child: Icon(
                                    Icons.credit_card,
                                    size: getWidth(30, 2),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: getWidth(8, 2),
                            ),
                            Column
                              (
                              mainAxisAlignment: MainAxisAlignment
                                  .center,
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: <Widget>
                              [
//                              Text('Email', style: TextStyle(
//                                  color: Color(0xccff3266),
//                                  fontSize: 13.0)),
                                Text('Pay',
                                    style: TextStyle(
                                        color: ColorGlobal
                                            .textColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: getWidth(20, 2)))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getHeight(24, 2),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.downToUp,
                              duration: Duration(milliseconds: 300),
                              child: ContactUs()),);
                      },
                      child: Container(
                        width: width,
                        color: Colors.transparent,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment
                              .center,
                          children: [
                            Material(
                              color: Color(0xcc3399fe),
                              borderRadius: BorderRadius.circular(
                                  getHeight(24, 2)),
                              child: Center
                                (
                                child: Padding
                                  (
                                  padding: EdgeInsets.all(
                                      getWidth(16, 2)),
                                  child: Icon(
                                    Icons.phone,
                                    size: getWidth(30, 2),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: getWidth(8, 2),
                            ),
                            Column
                              (
                              mainAxisAlignment: MainAxisAlignment
                                  .center,
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: <Widget>
                              [
//                              Text('Discounts', style: TextStyle(
//                                  color: Color(0xcc3399fe),
//                                  fontSize: 13.0)),
                                Text('Contact',
                                    style: TextStyle(
                                        color: ColorGlobal
                                            .textColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: getWidth(20, 2)))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
