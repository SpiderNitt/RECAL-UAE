import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/ColorGlobal.dart';

class CustomToolTip extends StatelessWidget {

  String text;

  CustomToolTip({this.text});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Text(text, style: GoogleFonts.lato(
        color: ColorGlobal.blueColor,
        decoration: TextDecoration.underline,
        fontSize: 17,
        fontWeight: FontWeight.w700,
      )),
      onTap: () {
        Fluttertoast.showToast(msg: "Copied Email Address",textColor: Colors.white,backgroundColor: Colors.green);
        Clipboard.setData(new ClipboardData(text: text));
      },
      onLongPress: () {
        Fluttertoast.showToast(msg: "Copied Email Address",textColor: Colors.white,backgroundColor: Colors.green);
        Clipboard.setData(new ClipboardData(text: text));
      },
    );
  }
}