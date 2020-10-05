import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/routes.dart';
import 'package:iosrecal/models/PositionModel.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:iosrecal/constants/Api.dart';
import 'package:iosrecal/constants/UIUtility.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:io' show Platform;

class JobDetail extends StatefulWidget {
  final PositionModel positionModel;
  JobDetail(this.positionModel);
  @override
  _JobDetailState createState() => _JobDetailState(positionModel);
}

class _JobDetailState extends State<JobDetail> {
  final PositionModel positionModel;
  _JobDetailState(this.positionModel);
  bool _hasInternet = true;
  UIUtility uiUtills = new UIUtility();

  initState() {
    super.initState();
  }

  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }
  navigateAndReload(){
    Navigator.pushNamed(context, LOGIN_SCREEN, arguments: true)
        .then((value) {
      Navigator.pop(context);
      setState(() {

      });
    });
  }

  Future<bool> onTimeOut(){
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('Session Timeout'),
        content : Text('Login in continue'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => navigateAndReload(),
            child: Text("OK"),
          ),
        ],
      ),
    ) ??
        false;
  }


  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    uiUtills.updateScreenDimesion(width: width, height: height);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorGlobal.whiteColor,
          leading: IconButton(
              icon: Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios, color: ColorGlobal.textColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              }
          ),
          title: Text(
            positionModel.position,
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: getWidth(10, 1), vertical: getHeight(10, 1)),
          child: Material(
            color: Colors.white,
            elevation: 5,
            borderRadius: BorderRadius.circular(getWidth(10, 1)),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: getHeight(20, 1), horizontal: getWidth(20, 1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        Center(child: Image.asset("assets/images/open_positions.png", height: getWidth(100, 1), width: getWidth(100, 1))),
                        SizedBox(
                          height: getHeight(10, 1),
                        ),
                        AutoSizeText(positionModel.position,
                          style: TextStyle(
                              color:
                              ColorGlobal.textColor,
                              fontWeight: FontWeight.w600,
                              fontSize: getWidth(22, 1)),
                          maxLines: 3,
                        ),
                        SizedBox(
                          height: getHeight(5, 1),
                        ),
                        AutoSizeText(positionModel.company,
                          style: TextStyle(
                              color: ColorGlobal.textColor.withOpacity(0.9),
                              fontSize: getWidth(18, 1)),
                          maxLines: 3,
                        ),
                        SizedBox(
                          height: getHeight(10, 1),
                        ),
                    positionModel.open_until!=null?
                    Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: getWidth(18, 1),
                              color: Colors.red.withOpacity(0.8),
                            ),
                            SizedBox(
                              width: getWidth(5, 1),
                            ),
                            AutoSizeText("Open Until: ${positionModel.open_until}",
                              style: TextStyle(
                                  color: ColorGlobal.textColor.withOpacity(0.8),
                                  fontWeight: FontWeight.w500,
                                  fontSize: getWidth(12, 1)),
                              maxLines: 2,
                            )
                          ],
                        ) : SizedBox(),
                    SizedBox(
                        height: getHeight(10, 1)
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: getHeight(10, 1)),
                      child: AutoSizeText('Job Description',
                        style: TextStyle(
                            color: ColorGlobal.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: getWidth(18, 1)),
                      ),
                    ),
                    AutoSizeText(positionModel.description,
                      style: TextStyle(
                          color: ColorGlobal.textColor,
                          fontSize: getWidth(17, 1)),
                      maxLines: 1000,
                    ),
                    SizedBox(
                        height: getHeight(8, 1)
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: getHeight(10, 1)),
                      child: AutoSizeText('Contact Details',
                        style: TextStyle(
                            color: ColorGlobal.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: getWidth(18, 1)),
                      ),
                    ),
                Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
            Icon(
            Icons.phone,
            size: getWidth(22, 1),
                color: Color(0xcc26cb3c),
          ),
          SizedBox(
            width: 3*width/100,
          ),
          Container(
            width: 67*width/100,
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: <Widget>[
                CustomToolTip(text: positionModel.contact,),
              ],
            ),
          ),
          ],
        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomToolTip extends StatelessWidget {

  String text;
  UIUtility uiUtills = new UIUtility();

  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }
  CustomToolTip({this.text});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    uiUtills.updateScreenDimesion(width: width, height: height);
    return new GestureDetector(
      child: AutoSizeText(text,
        style: TextStyle(
            color: ColorGlobal.textColor,
            fontSize: getWidth(17, 1)),
        maxLines: 2,
      ),
      onTap: () {
        Fluttertoast.showToast(msg: "Copied Contact Details",textColor: Colors.white,backgroundColor: Colors.green);
        Clipboard.setData(new ClipboardData(text: text));
      },
      onDoubleTap: () {
        Fluttertoast.showToast(msg: "Copied Contact Details",textColor: Colors.white,backgroundColor: Colors.green);
        Clipboard.setData(new ClipboardData(text: text));
      },
    );
  }
}

