import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Walkthrough.dart';


class IntroPage extends StatefulWidget {
  final List<Walkthrough> walkthroughList;
  final String pageName;
  IntroPage(this.walkthroughList, this.pageName);

  void skipPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, pageName);
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

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
      if (currentPage == widget.walkthroughList.length - 1) {
        lastPage = true;
      } else {
        lastPage = false;
      }
    });
  }
  Future<bool> _onBackPressed() {
    return Container(
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Container(
          color: new Color(0xFFEEEEEE),
          padding: const EdgeInsets.all(10.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Expanded(
                flex: 1,
                child: new Container(),
              ),
              new Expanded(
                flex: 3,
                child: new PageView(
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
                    new FlatButton(
                      child: new Text(lastPage ? "" : "SKIP",
                          style: new TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      onPressed: () => lastPage
                          ? null
                          : widget.skipPage(
                        context,
                      ),
                    ),
                    new FlatButton(
                      child: new Text(lastPage ? "LOGIN" : "NEXT",
                          style: new TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
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