import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:iosrecal/constants/UIUtility.dart';

class NodataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Center(
        child: Text("No data available",
            style: GoogleFonts.josefinSans(
                fontSize:
                    UIUtility().getProportionalHeight(height: 25, choice: 3),
                color: ColorGlobal.textColor)));
  }
}
