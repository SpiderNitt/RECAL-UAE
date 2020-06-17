import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import '../Constant/ColorGlobal.dart';

class AchievementsScreen extends StatefulWidget {
  @override
  _AchievementsScreenState createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorGlobal.whiteColor,
        title: Text(
          'Achievements',
          style: TextStyle(color: ColorGlobal.textColor),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 20),
        child: PageView.builder(
          itemCount: 10,
          controller: PageController(viewportFraction: 0.7),
          onPageChanged: (int index) => setState(() => _index = index),
          itemBuilder: (_, i) {
            return Transform.scale(
              scale: i == _index ? 0.95 : 0.85,
              child: Container(
                color: Colors.transparent,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.1)),
                        child: Container(
                          height: MediaQuery.of(context).size.width * 0.5,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: new BoxDecoration(
                            color: ColorGlobal.colorPrimaryDark,
                            image: new DecorationImage(
                              image: new AssetImage('assets/images/admin.jpeg'),
                              fit: BoxFit.contain,
                            ),
                            border: Border.all(
                                color: ColorGlobal.whiteColor, width: 2),
                            borderRadius: new BorderRadius.all(
                                Radius.circular(MediaQuery.of(context).size.width * 0.1)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          "Madhav Aggarwal",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 18,
                            letterSpacing: 1,
                            color: ColorGlobal.textColor.withOpacity(0.9),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        child: Text(
                          "BTech CSE, 2022",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 1,
                            color: ColorGlobal.textColor.withOpacity(0.6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        children: ["IOT", "Robotics", "AR"].map((title) {
                          return Card(
                            elevation: 2,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              color: ColorGlobal.textColor,
                              padding: EdgeInsets.all(5),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Center(
                                  child: Text(
                                    "$title",
                                    style: TextStyle(
                                        color: ColorGlobal.whiteColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            "Nomination for the 2021 Engelberger Robotics Awards are now being accepted. The awards will be presented in the categories of Leadership and Technology. Please click here to nominate a deserving individual in the field of robotics. Nominations are due by February 5, 2021. The 2021 awards will be presented during Automate, May 17-20, 2021 in Detroit, Michigan, USA.",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 1,
                              color: ColorGlobal.textColor.withOpacity(0.6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
