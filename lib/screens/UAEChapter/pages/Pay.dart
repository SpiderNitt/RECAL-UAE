import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:iosrecal/routes.dart';
import 'package:iosrecal/models/ChapterModel.dart';
import 'package:iosrecal/widgets/NoInternet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/constants/Api.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:connectivity/connectivity.dart';
import 'package:iosrecal/constants/UIUtility.dart';
import 'dart:io' show Platform;

class PayPage extends StatefulWidget {
  @override
  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  UIUtility uiUtills = new UIUtility();

  @override
  void initState() {
    super.initState();
    _pay();
    uiUtills = new UIUtility();
  }

  ChapterModel chapterDetails;
  String payDetails;
  int state = 0;
  int internet = 1;

  refresh(){
    setState(() {
      state=0;
      internet=1;
      _pay();
    });
  }

  Future<String> _pay() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        state = 1;
        internet=0;
      });
      Fluttertoast.showToast(
        msg: "Please connect to internet",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16,
      );
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

  Widget getPayDetails(){
    if(state==1){
      return Text(
        payDetails==null? 'No Data Available' : payDetails,
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
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    uiUtills.updateScreenDimesion(width: width, height: height);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorGlobal.whiteColor,
        leading: IconButton(
          icon: Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios, color: ColorGlobal.textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Pay',
          style: TextStyle(color: ColorGlobal.textColor),
        ),
      ),
      body: state ==0 ? (SpinKitDoubleBounce(color: ColorGlobal.blueColor,)) : internet == 0 ? Center(child: NoInternetScreen(notifyParent: refresh)) : SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(getWidth(12, 2), getHeight(16, 2), getWidth(12, 2), 0.0),
              child: Text(
                'If you are paying for your annual membership or contributing towards an upcoming event, please transfer/deposit in the following bank account',
                style: TextStyle(
                  color: const Color(0xFF544F50),
                  fontSize: getWidth(18, 2),
                  letterSpacing: 1.2,
                  wordSpacing: 1.2,
                ),
              ),
            ),
            SizedBox(height: getHeight(10, 2)),

            state==0 ? SpinKitDoubleBounce(
              color: Colors.lightBlueAccent,
            ) :  Card(
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
                    fontSize: getWidth(18, 2),
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
                  'Once the payment is received, you will receive a notification on this app within 24 hours. ',
                  style: TextStyle(
                    fontSize: getWidth(18, 2),
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
          ],
        ),
      ),
    );
  }
}
