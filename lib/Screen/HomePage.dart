import 'package:flutter/services.dart';
import 'package:iosrecal/Support/SupportScreen.dart';

import '../Home/HomeActivity.dart';
import '../Achievements/AchievementsScreen.dart';
import '../Home/HomeScreen.dart';
import '../Events/EventsScreen.dart';
import '../UAEChapter/ChapterScreen.dart';
import '../Profile/ProfileScreen.dart';
import '../Home/SocialMedia.dart';
import '../Constant/ColorGlobal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  int _index = 1;
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
  Widget _getHomeWidgets(index,context) {
    switch(index) {
      case 0: return (ChapterScreen());
      break;
//      case 1: return (AchievementsScreen());
//      break;
      case 1: return (HomeActivity());
      break;
      default:return(SupportScreen());
//      case 3: return(EventsScreen());
//      break;
//      case 4: return(ProfileScreen());
//      break;
//      default: return(ProfileScreen());
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit the App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: FlatButton(
                  color: Colors.green,
                  child: Text("NO"),
                ),
              ),
              new GestureDetector(
                onTap: () => SystemNavigator.pop(),
                child: FlatButton(
                  color: Colors.red,
                  child: Text("YES"),
                ),
              ),
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
          backgroundColor: Colors.transparent,
//        appBar: new AppBar(
//          backgroundColor: Colors.black.withOpacity(0.5),
//          actions: <Widget>[
//            IconButton(
//              icon: Container(
//                child: SvgPicture.asset(
//                  "assets/icons/Logout.svg",
//                  color: Colors.white70,
//                ),
//                height: 20,
//              ),
//              onPressed: () {
//                Navigator.of(context).pushReplacementNamed(LOGIN_SCREEN);
//              },
//            )
//          ],
//          title: Text(_pages[_index]),
//          elevation: 0.0,
//        ),
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
                _showPage = _getHomeWidgets(tappedIndex, context);
              });
            },
          ),
          body: _showPage,
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
