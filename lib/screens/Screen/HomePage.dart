import 'package:flutter/services.dart';
import '../Home/HomeActivity.dart';
import '../UAEChapter/ChapterScreen.dart';
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
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit the App'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                color: Colors.green,
                child: Text("NO"),
              ),
              FlatButton(
                onPressed: () => SystemNavigator.pop(),
                color: Colors.red,
                child: Text("YES"),
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
            animationCurve: Curves.easeInOutCubic,
            index: _index,
            animationDuration: Duration(milliseconds: 200),
            onTap: (int tappedIndex) =>
              setState(() {
                _showPage = _getHomeWidgets(tappedIndex, context);
              }),
          ),
          body: _showPage,
        ),
      ),
    );
  }
}
