import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:iosrecal/Constant/Constant.dart';
import 'package:iosrecal/models/ChapterModel.dart';
import 'package:iosrecal/screens/Home/NoInternet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/Endpoint/Api.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import '../Home/NoData.dart';
import 'package:connectivity/connectivity.dart';
import 'package:iosrecal/Constant/utils.dart';


class PayPage extends StatefulWidget {
  @override
  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  UIUtills uiUtills = new UIUtills();

  @override
  void initState() {
    super.initState();
    _pay();
    uiUtills = new UIUtills();
  }

  ChapterModel chapterDetails;
  String payDetails;
  int state = 0;
  int internet = 1;

  refresh(){
    setState(() {

    });
    state = 0;
    internet = 1;
    _pay();
  }

  Future<String> _pay() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        internet=0;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        Api.chapterVisionMission,
        headers: {
          "Accept": "application/json",
          "Cookie": "${prefs.getString("cookie")}",
        });
    ResponseBody responseBody = new ResponseBody();
    if (response.statusCode == 200) {
//        updateCookie(_response);
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      if (responseBody.status_code == 200) {
        chapterDetails =  ChapterModel.fromJson(responseBody.data);
        payDetails = chapterDetails.bank_account;
        setState(() {
          state = 1;
        });

      }else if(responseBody.status_code==401){
        onTimeOut();
      }else{
        setState(() {
          state = 2;
        });
      }
    }else{
      setState(() {
        state = 2;
      });
    }
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
      state = 0;
      internet = 1;
     _pay();
    });
  }

  Future<bool> onTimeOut(){
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Session Timeout'),
        content: new Text('Login to continue'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () async {
              //await _logoutUser();
              navigateAndReload();
            },
            child: FlatButton(
              color: Colors.red,
              child: Text("OK"),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  Widget getPayDetails(){
    if(state==0){
      return SpinKitDoubleBounce(
        color: Colors.lightBlueAccent,
      );
    }else if(state==1){
      return Text(
        payDetails,
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
        ),
      );
    }else if(state==2){
      return Text(
        'Please try again later',
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorGlobal.whiteColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorGlobal.textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Pay',
          style: TextStyle(color: ColorGlobal.textColor),
        ),
      ),
      body: internet == 0 ? Center(child: NoInternetScreen(notifyParent: refresh)) : SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(getWidth(12, 2), getHeight(16, 2), getWidth(12, 2), 0.0),
              child: Text(
                'If you are paying for your annual membership or contribution towards an upcoming event, please tranfer/deposit in the following bank account',
                style: TextStyle(
                  color: const Color(0xFF544F50),
                  fontSize: getHeight(18, 2),
                  letterSpacing: 1.2,
                  wordSpacing: 1.2,
                ),
              ),
            ),
            SizedBox(height: getHeight(10, 2)),
            Card(
              margin: EdgeInsets.fromLTRB(getWidth(16, 2), getHeight(16, 2), getWidth(16, 2), getHeight(16, 2)),
              color: Colors.blue[300],
              child: Padding(
                padding: EdgeInsets.all(getHeight(12, 2)),
                child: getPayDetails(),
              ),
            ),
            SizedBox(height: getHeight(10, 2)),
            Padding(
              padding: EdgeInsets.fromLTRB(getWidth(16, 2), 0.0, getWidth(16, 2), 0.0),
              child: Text(
                  'Note:',
                  style: TextStyle(
                    fontSize: getHeight(18, 2),
                    color: const Color(0xFF544F50),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    wordSpacing: 1.2,
                  )
              ),
            ),
            SizedBox(height: getHeight(6, 2)),
            Padding(
              padding: EdgeInsets.fromLTRB(getWidth(16, 2), 0.0, getWidth(16, 2), 0.0),
              child: Text(
                  '\u2022 Once the payment is received, you will receive a notification on this app within 24 hours. ',
                  style: TextStyle(
                    fontSize: getHeight(18, 2),
                    color: const Color(0xFF544F50),
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, getHeight(8, 2), 0.0, getHeight(4, 2)),
              child: Image(
                image: AssetImage('assets/images/pay_bg.jpg'),
                alignment: Alignment.bottomCenter,
              ),
            ),
//          Padding(
//            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
//            child: Text(
//              'https://www.freepik.com/free-photos-vectors/business. Business vector created by freepik - www.freepik.com',
//                style: TextStyle(
//                  fontSize: 10.0,
//                  color: Colors.grey[500],
//                ),
//            ),
//          )
          ],
        ),
      ),
    );
  }
}
