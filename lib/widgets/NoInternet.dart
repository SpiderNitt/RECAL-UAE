import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:iosrecal/screens/Recal/home/HomeScreen.dart';

class NoInternetScreen extends StatelessWidget {
  final Function() notifyParent;
  NoInternetScreen({Key key, @required this.notifyParent}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // SizedBox(
                //   height: height / 9,
                // ),
                Center(
                  child: FadeIn(
                    child: Text(
                      "NOT CONNECTED TO INTERNET",
                      style: TextStyle(
                          fontSize: 25,
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
                      'assets/images/no_internet.png',
                    ),
                    height: height / 3,
                    fit: BoxFit.cover,
                    //width: width / 1.5,
                  ),
                ),
                Center(
                  child: FlatButton.icon(
                    color: const Color(0xff3AAFFA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    onPressed: () {
                      if (notifyParent != null) notifyParent();
                      print("Pressed");
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: ColorGlobal.textColor,
                    ),
                    label: Text("Refresh Page",
                        style: GoogleFonts.lato(
                          color: ColorGlobal.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                )
                //SizedBox(height: 12.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
