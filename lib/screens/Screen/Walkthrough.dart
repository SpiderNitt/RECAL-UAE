import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';

class Walkthrough extends StatefulWidget {
  final title;
  final content;
  final imageIcon;
  final imagecolor;
  final asset;

  Walkthrough(
      {this.title,
        this.content,
        this.imageIcon,
        this.imagecolor = Colors.redAccent, this.asset});

  @override
  WalkthroughState createState() {
    return new WalkthroughState();
  }
}

class WalkthroughState extends State<Walkthrough>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

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
    animationController.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        animationDuration: new Duration(milliseconds: 500),
        elevation: 2.0,
        borderRadius: new BorderRadius.all(Radius.circular(20.0)),
        shadowColor: Colors.grey.withOpacity(0.7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Transform(
                  transform:
                  new Matrix4.translationValues(animation.value, 0.0, 0.0),
                  child: Text(
                    widget.title,
                    style: GoogleFonts.lato(
                        fontSize: 20,
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
                padding: const EdgeInsets.all(10.0),
                child: Transform(
                  transform:
                  new Matrix4.translationValues(animation.value, 0.0, 0.0),
                  child: Text(
                    widget.content,
                    style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: ColorGlobal.textColor
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Center(
              child: new Icon(
                widget.imageIcon,
                size: 70.0,
                color: widget.imagecolor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}