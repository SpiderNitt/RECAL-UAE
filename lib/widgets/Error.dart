import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import '../constants/UIUtility.dart';

class Error8Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    UIUtility().updateScreenDimesion(width: width, height: height);
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: UIUtility().getProportionalHeight(height: 40, choice: 3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // SizedBox(
                //   height: height / 9,
                // ),
                Center(
                  child: FadeIn(
                    child: Text(
                      "ERROR!!",
                      style: TextStyle(
                          fontSize: UIUtility().getProportionalWidth(width: 25, choice: 3),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff3AAFFA)),
                      textAlign: TextAlign.center,
                    ),
                    duration: Duration(milliseconds: 2000),
                    curve: Curves.easeIn,
                  ),
                ),
                Center(
                  child: FadeIn(
                    child: Text(
                      "Something went wrong :(",
                      style: TextStyle(
                          fontSize: UIUtility().getProportionalWidth(width: 25, choice: 3),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff3AAFFA)),
                      textAlign: TextAlign.center,
                    ),
                    duration: Duration(milliseconds: 2000),
                    curve: Curves.easeIn,
                  ),
                ),
                SizedBox(
                  height: height / 100,
                ),
                Center(
                  child: Image(
                    image: AssetImage(
                      'assets/images/errorbg.jpg',
                    ),
                    height: height / 2.5,
                    fit: BoxFit.fill,
                    //width: width / 1.5,
                  ),
                ),
                SizedBox(height: UIUtility().getProportionalHeight(height: 12, choice: 3)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
