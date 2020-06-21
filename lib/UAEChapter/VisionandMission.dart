import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

import '../Constant/ColorGlobal.dart';


class VisionMission extends StatefulWidget {
  @override
  _FadeInDemoState createState() => _FadeInDemoState();
}

class _FadeInDemoState extends State<VisionMission> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: ColorGlobal.whiteColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: ColorGlobal.textColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'Vision and Mission',
                style: TextStyle(color: ColorGlobal.textColor),
              ),
            ),
            body: Center(
              child: FractionallySizedBox(
                  widthFactor: 0.9,
                  heightFactor: 0.8,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                        colors: [
                          Color(0xFFDAD8D9),
                          Color(0xFFD9C8C0).withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFEAE3E3),
                          spreadRadius: 2,
                          blurRadius: 0,
                          // changes position of shadow
                        ),
                      ],
                      border: Border.all(
                        width: 2,
                        color: Color(0xFF544F50), //                   <--- border width here
                      ),
                      color: Color(0xFF544F50),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          (22.0),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                        Image.asset('assets/images/Vision.png'),
                          FadeIn(
                            child: Text(
                              "VISION",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            // Optional paramaters
                            duration: Duration(milliseconds: 2000),
                            curve: Curves.easeIn,
                          ),
                          FadeIn(
                            child: Text(
                              "\"Aspire to be the most active , inclusive and supportive alumni association globally\"",
                              style: TextStyle(
                                fontSize: 15,
                                color: ColorGlobal.textColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            // Optional paramaters
                            duration: Duration(milliseconds: 2000),
                            curve: Curves.easeIn,
                          ),
                        Image.asset('assets/images/mission.png'),
                          FadeIn(
                            child: Text(
                              "MISSION",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            // Optional paramaters
                            duration: Duration(milliseconds: 2000),
                            curve: Curves.easeIn,
                          ),
                          FadeIn(
                            child: Text(
                              "\"RECAL is a non-profit association that develops and strengthens the ties between the alumini of the NIT, Trichy in UAE by providing tangible benefits in social and business networking, mentor support and jobs\"",
                              style: TextStyle(
                                fontSize: 15,
                                color: ColorGlobal.textColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            // Optional paramaters
                            duration: Duration(milliseconds: 2000),
                            curve: Curves.easeIn,
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
}
