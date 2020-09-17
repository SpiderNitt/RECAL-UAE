
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/screens/Achievements/AchievementsScreen.dart';
import 'package:page_transition/page_transition.dart';
import 'ContactUs.dart';
import 'Pay.dart';
import 'VisionandMission.dart';
import 'Sponsors.dart';
import 'CoreComm.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';

class ChapterScreen extends StatefulWidget {
  @override
  _ChapterScreenState createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
                style: GoogleFonts.josefinSans(color: ColorGlobal.textColor, fontWeight: FontWeight.bold,fontSize: 20),
              ),
            ],
          ),
        ),

        body: Column(
          children: <Widget>[
            SizedBox(height: 24.0),
//                Center(
//                  child: Container(
//                    margin: EdgeInsets.symmetric(vertical: 15),
//                    width: width*0.7,
//                    height: width*0.3,
//                    padding: EdgeInsets.symmetric(horizontal: 20),
//                    decoration: new BoxDecoration(
//                      color: ColorGlobal.colorPrimaryDark,
//                      image: new DecorationImage(
//                        image: new AssetImage('assets/images/recal_logo.jpg'),
//                        fit: BoxFit.fill,
//                      ),
//                      borderRadius: BorderRadius.circular(width*0.1)
//                      ),
//                  ),
//      ),
//                  Padding(
//                    padding: const EdgeInsets.symmetric(horizontal: 20),
//                    child: ListBody(
//                      children: <Widget>[
//                        Text(
//                          'RECAL UAE CHAPTER',
//                          style: GoogleFonts.josefinSans(
//                            color: ColorGlobal.textColor,
//                            fontSize: 20.0,
//                            fontWeight: FontWeight.w600,
//                          ),
//                          textAlign: TextAlign.center,
//                        ),
//                          Center(
//                            child: Padding(
//                              padding: const EdgeInsets.only(top: 10),
//                              child: Container(
//                                  padding: const EdgeInsets.only(top: 8, bottom: 8),
//                                  decoration: const BoxDecoration(
//                                    border: Border(
//                                      top: BorderSide(width: 0),
//                                      bottom: BorderSide(width: 0),
//                                    ),
//                                  ),
//                                  child: Text("REC's (NIT Trichy) Alumni Association (RECAL).",
//                                  style: TextStyle(fontSize: 15),),
//                              ),
//                            ),
//                          ),
//                      ],
//                    ),
//                  ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10),
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
                                  24.0),
                              child: Center
                                (
                                  child: Padding
                                    (
                                    padding: const EdgeInsets.all(
                                        16.0),
                                    child: Icon(
                                      Icons.list,
                                      size: 30.0,
                                      color: Colors.white,
                                    ),
                                  )
                              )
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Column
                            (
                            mainAxisAlignment: MainAxisAlignment
                                .center,
                            crossAxisAlignment: CrossAxisAlignment
                                .start,
                            children: <Widget>
                            [
//                                Text('Name', style: TextStyle(
//                                    color: Color(0xfff4c83f),
//                                    fontSize: 13.0)),
                              Text('Vision and Mission',
                                  style: TextStyle(
                                      color: ColorGlobal.textColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.0))
                            ],
                          ),
                        ]
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
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
                                24.0),
                            child: Center
                              (
                                child: Padding
                                  (
                                  padding: const EdgeInsets.all(
                                      16.0),
                                  child: Icon(
                                    Icons.person,
                                    size: 30.0,
                                    color: Colors.white,
                                  ),
                                )
                            )
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: <Widget>[
//                              Text('Contact',
//                                  style: TextStyle(
//                                      color:
//                                      Color(0xcc982ef0),
//                                      fontSize: 13.0)),
                            Text('Core Committee',
                                style: TextStyle(
                                    color: ColorGlobal
                                        .textColor,
                                    fontWeight:
                                    FontWeight.w500,
                                    fontSize: 20.0)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment
                          .center,
                      children: [
                        Material(
                          color: Color(0xccff3266),
                          borderRadius: BorderRadius.circular(
                              24.0),
                          child: Center
                            (
                            child: Padding
                              (
                              padding: const EdgeInsets.all(
                                  16.0),
                              child: Icon(
                                Icons.credit_card,
                                size: 30.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
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
                                    fontSize: 20.0))
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment
                          .center,
                      children: [
                        Material(
                          color: Color(0xcc3399fe),
                          borderRadius: BorderRadius.circular(
                              24.0),
                          child: Center
                            (
                            child: Padding
                              (
                              padding: const EdgeInsets.all(
                                  16.0),
                              child: Icon(
                                Icons.phone,
                                size: 30.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
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
                            Text('Contact Us',
                                style: TextStyle(
                                    color: ColorGlobal
                                        .textColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.0))
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment
                          .center,
                      children: [
                        Material(
                          color: Color(0xcc26cb3c),
                          borderRadius: BorderRadius.circular(
                              24.0),
                          child: Center
                            (
                            child: Padding
                              (
                              padding: const EdgeInsets.all(
                                  16.0),
                              child: Icon(
                                Icons.brightness_low,
                                size: 30.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
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
                            Text('Achievements',
                                style: TextStyle(
                                    color: ColorGlobal
                                        .textColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.0))
                          ],
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}
