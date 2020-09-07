import 'package:flutter/material.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:transparent_image/transparent_image.dart';
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
          leading: IconButton(icon:Icon(Icons.close),onPressed: ()=>Navigator.of(context).pop(),),
        ),
        backgroundColor: Colors.black,
      body: Center(child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image:url,fit: BoxFit.cover,)),
      ),
    );
  }
}
