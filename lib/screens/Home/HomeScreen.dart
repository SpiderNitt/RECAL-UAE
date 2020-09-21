import 'package:flutter/services.dart';

import 'HomeActivity.dart';
import '../Achievements/AchievementsScreen.dart';
import 'HomeScreen.dart';
import '../Events/EventsScreen.dart';
import '../UAEChapter/ChapterScreen.dart';
import '../Profile/ProfileScreen.dart';
import 'SocialMedia.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../Support/supportScreen.dart';


class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  int _index = 1;
  final List<Widget> pages = [
    ChapterScreen(
      key: PageStorageKey('Chapter'),
    ),
    HomeActivity(
      key: PageStorageKey('Home'),
    ),
    SupportScreen(
      key: PageStorageKey('Support'),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  Widget _showPage= Scaffold(
    body: HomeActivity(),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    Navigator.pushReplacement(
//        context,
//        PageTransition(
//            type: PageTransitionType.rightToLeftWithFade,
//            child: Login()));
  }


  static List<String> _pages = [
    "UAE Chapter",
    "Achievements",
    "Home",
    "Events",
    "Profile",
  ];

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('Are you sure?'),
        content : Text('Do you want to exit the app?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          new GestureDetector(
            child: FlatButton(
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop(true),
              child: Text("YES"),
            ),
          )
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorGlobal.whiteColor,

          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: ColorGlobal.whiteColor,
            color: Colors.black,
            buttonBackgroundColor: ColorGlobal.blueColor,
            height: 50,
            items: <Widget>[
              Icon(
                Icons.account_balance,
                size: 30,
                color: ColorGlobal.color3,
              ),
              //     SvgPicture.asset("assets/icons/ac.svg",color:color_shades.color4,height: 30,),
//              Icon(
//                Icons.assistant_photo,
//                size: 30,
//                color: ColorGlobal.color3,
//              ),
              Icon(
                Icons.home,
                size: 30,
                color: ColorGlobal.color3,
              ),
              Icon(
                Icons.rate_review,
                size: 30,
                color: ColorGlobal.color3,
              ),
//              Icon(
//                Icons.person,
//                size: 30,
//                color: ColorGlobal.color3,
//              ),
            ],
            animationCurve: Curves.bounceInOut,
            index: _index,
            animationDuration: Duration(milliseconds: 200),
            onTap: (int tappedIndex) {
              setState(() {
                _showPage = pages[tappedIndex];
              });
            },
          ),
          body: PageStorage(
            child: _showPage,
            bucket: bucket,
          ),
//            Stack(
//              children: [
//                ClipPath(
//                  child: Container(
//                    height: MediaQuery.of(context).size.height / 2,
//                    decoration: BoxDecoration(
//                      image: DecorationImage(
//                          image: AssetImage("assets/images/admin.jpeg"),
//                          fit: BoxFit.cover),
//                    ),
//                  ),
//                  clipper: Header(),
//                ),
//                Container(
//                  child: _showPage,
//                )
//              ],
//            ),
        ),
      ),
    );
  }
}