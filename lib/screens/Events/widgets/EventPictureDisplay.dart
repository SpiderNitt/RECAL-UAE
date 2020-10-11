import 'package:flutter/material.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:io' show Platform;
class EventPictureDisplay extends StatelessWidget {
  String url;
  EventPictureDisplay(this.url);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: ColorGlobal.whiteColor),
          leading: IconButton(
              icon: Icon(
                Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                color: ColorGlobal.textColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        backgroundColor: Colors.black,
      body: Center(child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image:url,fit: BoxFit.cover,)),
      ),
    );
  }
}
