
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'ContactUs.dart';
import 'Pay.dart';
import 'VisionandMission.dart';
import 'Sponsors.dart';
import 'CoreComm.dart';
import '../Constant/ColorGlobal.dart';

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
        appBar: AppBar(
          backgroundColor: ColorGlobal.whiteColor,
          title: Text(
            'UAE Chapter',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),

        body: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    width: width*0.7,
                    height: width*0.3,
                    padding: EdgeInsets.symmetric(horizontal: 20),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListBody(
                      children: <Widget>[
                        Text(
                          "RECAL UAE CHAPTER",
                          style: Theme.of(context).textTheme.title,
                          textAlign: TextAlign.center,
                        ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(width: 0),
                                      bottom: BorderSide(width: 0),
                                    ),
                                  ),
                                  child: Text("REC's (NIT Trichy) Alumni Association (RECAL).",
                                  style: TextStyle(fontSize: 15),),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.list,size: 30),
                        title: Text('Vision and Mission'),
                        onTap: (){
                          Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.downToUp,
                                duration: Duration(milliseconds: 300),
                                child: VisionMission()),);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.person,size: 30),
                        title: Text('Core Committee'),
                        onTap: (){
                          Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.leftToRight,
                                duration: Duration(milliseconds: 300),
                                child: CoreComm()),);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.credit_card,size: 30,),
                        title: Text('Pay'),
                        onTap: (){
                          Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 300),
                                child: PayPage()),);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.phone,size: 30),
                        title: Text('Contact us'),
                        onTap: (){
                          Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 300),
                                child: ContactUs()),);
                        },
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
