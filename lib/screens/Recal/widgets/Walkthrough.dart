
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:iosrecal/constants/UIUtility.dart';

class Walkthrough extends StatefulWidget {
  final title;
  final content;
  final imageIcon;
  final imagecolor;
  final asset;
  final picture;


  Walkthrough(
      {this.title,
        this.content,
        this.imageIcon,
        this.imagecolor = Colors.redAccent, this.asset, this.picture});

  @override
  WalkthroughState createState() {
    return new WalkthroughState();
  }
}

class WalkthroughState extends State<Walkthrough>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;
  UIUtility uiUtills = new UIUtility();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));
    animation = new Tween(begin: -250.0, end: 0.0).animate(new CurvedAnimation(
        parent: animationController, curve: Curves.easeInOut));
    animation.addListener(() => setState(() {}));
    animationController.forward();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.removeListener(() => setState(() {}));
    animationController.dispose();
  }
  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    uiUtills.updateScreenDimesion(width: width, height: height);
    return Card(
//          animationDuration: new Duration(milliseconds: 500),
        elevation: 5.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius:
            new BorderRadius.circular(getHeight(20, 1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            widget.picture == null ? SizedBox() :
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: getHeight(15, 2)),
                width: width*0.7,
                height: width*0.3,
                padding: EdgeInsets.symmetric(horizontal: getWidth(20,2)),
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
            Center(
              child: Padding(
                padding: EdgeInsets.all(getHeight(10, 1)),
                child: Transform(
                  transform:
                  new Matrix4.translationValues(animation.value, 0.0, 0.0),
                  child: Text(
                    widget.title,
                    style: GoogleFonts.josefinSans(
                        fontSize: getWidth(25, 1),
                        fontWeight: FontWeight.bold,
                        color: ColorGlobal.textColor
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(getHeight(10, 1)),
                child: Transform(
                  transform:
                  new Matrix4.translationValues(animation.value, 0.0, 0.0),
                  child: Text(
                    widget.content,
                    style: GoogleFonts.josefinSans(
                        fontSize: getWidth(20, 1),
                        fontWeight: FontWeight.w700,
                        color: ColorGlobal.textColor
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Center(
              child: widget.picture == null ? Icon(
                widget.imageIcon,
                size: getHeight(70, 1),
                color: widget.imagecolor,
              ) : SizedBox(),
            ),
          ],
        ),
    );
  }
}