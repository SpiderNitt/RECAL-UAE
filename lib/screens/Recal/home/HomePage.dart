import 'package:flutter/services.dart';
import 'HomeScreen.dart';
import '../../UAEChapter/ChapterScreen.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../../Support/SupportScreen.dart';


class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
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
  }

  Widget _getHomeWidgets(index,context) {
    switch(index) {
      case 0: return (ChapterScreen());
      break;
      case 1: return (HomeActivity());
      break;
      default: return(SupportScreen());
    }
  }
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
            buttonBackgroundColor: const Color(0xFF6289ce),
            height: 50,
            items: <Widget>[
              Icon(
                Icons.account_balance,
                size: 30,
                color: ColorGlobal.color3,
              ),
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
        ),
      ),
    );
  }
}