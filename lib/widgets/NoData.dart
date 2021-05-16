import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/ColorGlobal.dart';
import '../constants/UIUtility.dart';

class NodataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    UIUtility().updateScreenDimesion(width: width, height: height);
    return Center(
        child: Text("No data available",
            style: GoogleFonts.josefinSans(
                fontSize:
                    UIUtility().getProportionalWidth(width: 25, choice: 3),
                color: ColorGlobal.textColor)));
  }
}
