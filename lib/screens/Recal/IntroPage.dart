import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:iosrecal/routes.dart';
import 'package:iosrecal/constants/UIUtility.dart';
import 'widgets/Walkthrough.dart';


class IntroPage extends StatefulWidget {

  final List<Walkthrough> walkthroughList = [
    Walkthrough(
      title: "Welcome to REC/NIT Trichy Alumni Association",
      content: "(UAE Chapter)",
      picture: "RECAL",
      imageIcon: Icons.people,
      imagecolor: Colors.blue,
      asset: null,
    ),
    Walkthrough(
      title: "Events",
      content: "Get details about upcoming networking events, felicitations and alumni achievements",
      imageIcon: Icons.event,
      imagecolor: Colors.purple,
      asset: "assets/images/feed.png",

    ),
    Walkthrough(
      title: "Mentorship",
      content: "Join our Mentor Groups",
      imageIcon: Icons.school,
      imagecolor: Colors.green,
      asset: "assets/images/writementor.jpeg",
    ),
    Walkthrough(
      title: "Employment",
      content: "Get jobs",
      imageIcon: Icons.card_travel,
      imagecolor: Colors.deepPurpleAccent,
      asset: "assets/images/socialBusiness.jpg",
    ),
  ];

  void skipPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, LOGIN_SCREEN);
  }

  @override
  IntroPageState createState() {
    return new IntroPageState();
  }
}

class IntroPageState extends State<IntroPage> {
  final PageController controller = new PageController();
  int currentPage = 0;
  bool lastPage = false;
  bool firstPage=true;
  UIUtility uiUtills = new UIUtility();

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
      if (currentPage == widget.walkthroughList.length - 1) {
        lastPage = true;
      } else {
        lastPage = false;
      }
      if(currentPage==0)
        firstPage=true;
      else
        firstPage=false;
    });
  }
  Future<bool> _onBackPressed() {
    SystemNavigator.pop();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uiUtills = new UIUtility();
  }
  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    uiUtills.updateScreenDimesion(width: width, height: height);
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(getHeight(10, 1)),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Expanded(
                flex: 1,
                child: new Container(),
              ),
              new Expanded(
                flex: 3,
                child: new PageView (
                  children: widget.walkthroughList,
                  controller: controller,
                  onPageChanged: _onPageChanged,
                ),
              ),
              new Expanded(
                flex: 1,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
//                    lastPage ? Container() : FlatButton(
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(10)),
//                      child: new Text(lastPage ? "" : "SKIP",
//                          style: new TextStyle(
//                              color: Colors.white,
//                              fontWeight: FontWeight.bold,
//                              fontSize: 16.0)),
//                      onPressed: () => lastPage
//                          ? null
//                          : widget.skipPage(
//                        context,
//                      ),
//                      color: ColorGlobal.textColor,
//                    ),
                     firstPage ? Container() : FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(getHeight(10, 1))),
                      color: ColorGlobal.textColor,
                      child: new Text("BACK",
                          style: new TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: getHeight(16, 1))),
                      onPressed: () => controller.jumpToPage(currentPage-1),
                    ),

                    new FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(getHeight(10, 1))),
                      color: ColorGlobal.textColor,
                      child: new Text(lastPage ? "LOGIN" : "NEXT",
                          style: new TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: getHeight(16, 1))),
                      onPressed: () => lastPage
                          ? widget.skipPage(context)
                          : controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}