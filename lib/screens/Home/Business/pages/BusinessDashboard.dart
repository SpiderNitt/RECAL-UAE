import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iosrecal/widgets/NoData.dart';
import 'package:iosrecal/widgets/NoInternet.dart';
import 'package:iosrecal/widgets/Error.dart';
import 'package:iosrecal/models/MemberModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:iosrecal/routes.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/EventModel.dart';
import 'package:iosrecal/models/BusinessMemberModel.dart';
import 'package:iosrecal/constants/Api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:iosrecal/constants/UIUtility.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<charts.Series<Gender, String>> _seriesGenderPieData;
  List<charts.Series<SandB, String>> _seriesSAndBPieData;
  var data =new Map<String, int>();
  var events = new List<EventModel>();
  var members = new List<BusinessMemberModel>();
  var users = new List<MemberModel>();
  var final_members = new List<BusinessMemberModel>();
  int state = 0;
  bool _hasError = false;
  bool _internet = true;
  UIUtility uiUtills = new UIUtility();

  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }

  Future<bool> _fetchEvents() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        print("set internet to false");
        _internet = false;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http
        .get(
        Api.getAllEvents, headers: {
      "Accept": "application/json",
      "Cookie": "${prefs.getString("cookie")}",
    });
    ResponseBody responseBody = new ResponseBody();
    if (response.statusCode == 200) {
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      if (responseBody.status_code == 200) {
        List list = responseBody.data;
        events = list.map((model) => EventModel.fromJson(model)).toList();
        data['All Events'] = events.length;
        int social=0;
        events.forEach((element) {
          if(element.event_type=="Social"){
            social++;
          }
          data['Social Events'] = social;
          data['Business Events'] = events.length - social;

        });

          state += 1;
      }else if(responseBody.status_code==401){
        onTimeOut();
      }else{
          state+=1;
          _hasError = true;
      }
    }else{
        state+=1;
        _hasError = true;
    }
    return true;
  }

  navigateAndReload(){
    Navigator.pushNamed(context, LOGIN_SCREEN, arguments: true)
        .then((value) {
      Navigator.pop(context);
      setState(() {

      });
      state = 0;
      _hasError = false;
      _internet = true;
      _fetchEvents();
      _fetchAllUsers();
      uiUtills = new UIUtility();
        });
  }

  refresh(){
    setState(() {

    });
    state = 0;
    _hasError = false;
    _internet = true;
    _fetchEvents();
    _fetchAllUsers();
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

  _fetchSpecificUsers() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http
        .get(
        Api.businessMembers, headers: {
      "Accept": "application/json",
      "Cookie": "${prefs.getString("cookie")}",
    });
    ResponseBody responseBody = new ResponseBody();
    if (response.statusCode == 200) {
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      if (responseBody.status_code == 200) {
        List list = responseBody.data;
        members = list.map((model) => BusinessMemberModel.fromJson(model)).toList();
        int dealValue=0;
        List names = List<String>();
        members.forEach((element) {
          if(int.tryParse(element.deal_value)!=null)
          dealValue += int.parse(element.deal_value);
          if(!names.contains(element.name)) {
            final_members.add(element);
            names.add(element.name);
          }
        });
        data['Business Members'] = final_members.length;
        data['Social Members'] = data['All Members'] - final_members.length;
        data['All Deals'] = members.length;
        data['Deals Value'] = dealValue;
        await _generatePieData();

      }else{
          state+=1;
          _hasError = true;
      }
    }else{
        state+=1;
        _hasError = true;
    }
  }

  Future<bool> _fetchAllUsers() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http
        .get(
        Api.allUsers, headers: {
      "Accept": "application/json",
      "Cookie": "${prefs.getString("cookie")}",
    });
    ResponseBody responseBody = new ResponseBody();
    if (response.statusCode == 200) {
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      if (responseBody.status_code == 200) {
        List list = responseBody.data;
        users = list.map((model) => MemberModel.fromJson(model)).toList();
        data['All Members'] = users.length;
        int male = 0;
        users.forEach((element) {
          if(element.gender=="male"){
            //print(element.name);
            male++;
          }

        });
        data['Male'] = male;
        data['Female'] = users.length - male;
        await _fetchSpecificUsers();
          state += 1;
        }else{
          state+=1;
          _hasError = true;
      }
      }else{
        state+=1;
        _hasError = true;
    }
    return true;
    }

  _generatePieData(){
    var genderPieData =[
      new Gender('Male', data['Male'], Color(0xcc3399fe)),
      new Gender('Female', data['Female'], Color(0xccff3266)),
    ];

    var sAndBPieData =[
      new SandB('Social', data['Social Members'], Color(0xcc982ef0)),
      new SandB('Business', data['Business Members'], Color(0xcc26cb3c)),
    ];
    _seriesGenderPieData = List<charts.Series<Gender, String>>();
    _seriesSAndBPieData = List<charts.Series<SandB, String>>();
    _seriesGenderPieData.add(
      charts.Series(
        data: genderPieData,
        domainFn: (Gender gender, _) => gender.gender,
        measureFn: (Gender gender, _) => gender.genderval,
        colorFn: (Gender gender, _) =>
            charts.ColorUtil.fromDartColor(gender.colorval),
        id: 'Gender distribution',
        labelAccessorFn: (Gender row, _) => '${row.gender}',
      ),
    );

    _seriesSAndBPieData.add(
      charts.Series(
        data: sAndBPieData,
        domainFn: (SandB sandB, _) => sandB.types,
        measureFn: (SandB sandB, _) => sandB.typeval,
        colorFn: (SandB sandB, _) =>
            charts.ColorUtil.fromDartColor(sandB.colorval),
        id: 'Gender distribution',
        labelAccessorFn: (SandB row, _) => '${row.types}',
      ),
    );
      print("reached pie chart");
      print("state is : " + state.toString());
      state+=1;
  }

  Future<Map<String, int>> makeRequests() async {
    //var value = <Map<String, dynamic>>[];
    var r1 = _fetchEvents();
    var r2 = _fetchAllUsers();
    await Future.wait([r1, r2]); // list of Responses
    print("returning data");
    return data;
  }


  @override
  void initState() {
    super.initState();
    _seriesGenderPieData = List<charts.Series<Gender, String>>();
    _seriesSAndBPieData = List<charts.Series<SandB, String>>();
    //_generatePieData();
  }

  Material myItems(IconData icon, String heading, int color) {
    return Material(
      color: Colors.white,
      elevation: 5.0,
      borderRadius: BorderRadius.circular(getHeight(24, 2)),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(getHeight(8, 2)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(getHeight(8, 2)),
                      child: Text(
                        heading,
                        style: TextStyle(
                          color: new Color(color),
                          fontSize: getHeight(20, 2),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: new Color(color),
                    borderRadius: BorderRadius.circular(getHeight(24, 2)),
                    child: Padding(
                      padding: EdgeInsets.all(getHeight(16, 2)),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: getHeight(30, 2),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Material dealsItem(int color) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(getHeight(24, 2)),
      child: Padding(
        padding: EdgeInsets.all(getHeight(24, 2)),
        child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>
                    [
                      Text('Total deals', style: TextStyle(color: Color(color))),
                      Text(data['All Deals'].toString(), style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w700, fontSize: getWidth(34, 2))),
                      SizedBox(
                        height: 24.0,
                      ),
                      Text('Total value', style: TextStyle(color: Color(color))),
                      Text(data['Deals Value'].toString(), style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w700, fontSize: getWidth(34, 2))),
                    ],
                  ),
                  Material(
                      color: Color(color),
                      borderRadius: BorderRadius.circular(getHeight(24, 2)),
                      child: Center(
                          child: Padding(
                        padding: EdgeInsets.all(getWidth(16, 2)),
                        child: Image(
                          image: AssetImage('assets/images/deals.png'),
                          height: getWidth(30, 2),
                          width: getWidth(30, 2),
                        ),
                      )))
                ]),
          ],
        ),
      ),
    );
  }

  Material eventsItem(int color) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(getHeight(24, 2)),
      child: Padding(
        padding: EdgeInsets.all(getHeight(24, 2)),
        child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>
                    [
                      Text('Total events', style: TextStyle(color: Color(color))),
                      Text(data['All Events'].toString(), style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w700, fontSize: getWidth(34, 2))),
                    ],
                  ),
                  Material(
                      color: Color(color),
                      borderRadius: BorderRadius.circular(getHeight(24, 2)),
                      child: Center(
                          child: Padding(
                        padding: EdgeInsets.all(getWidth(16, 2)),
                        child: Image(
                          image: AssetImage('assets/images/calendar.png'),
                          height: getWidth(30, 2),
                          width: getWidth(30, 2),
                          color: Colors.white,
                        ),
                      )))
                ]),
            SizedBox(
              height: getHeight(24, 2),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Image(
                      image: AssetImage('assets/images/social_db.png'),
                      height: getWidth(30, 2),
                      width: getWidth(30, 2),
                    ),
                    SizedBox(
                      height: getHeight(8, 2),
                    ),
                    Text(
                        data['Social Events'].toString(),
                        style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w400, fontSize: getWidth(22, 2))
                    ),
                  ],
                ),
                Column(
                  children: [
                    Image.asset(
                      'assets/images/business_db.png',
                      height: getWidth(30, 2),
                      width: getWidth(30, 2),
                    ),
                    SizedBox(
                      height: getHeight(8, 2),
                    ),
                    Text(
                        data['Business Events'].toString(),
                        style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w400, fontSize: getWidth(22, 2))
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Material membersItem(int color) {
    final double width = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(getHeight(24, 2)),
      child: Padding(
        padding: EdgeInsets.all(getHeight(24, 2)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>
                    [
                      Text('Total members', style: TextStyle(color: Color(color))),
                      Text(data['All Members'].toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: getWidth(34, 2))),
                    ],
                  ),
                  Material(
                      color: Color(color),
                      borderRadius: BorderRadius.circular(getHeight(24, 2)),
                      child: Center(
                          child: Padding(
                        padding: EdgeInsets.all(getWidth(16, 2)),
                        child:
                            Icon(Icons.group, color: Colors.white, size: getWidth(30, 2)),
                      )))
                ]),
            SizedBox(
              height: getHeight(24, 2),
            ),
            Container(
              height: getHeight(200, 2),
              child: charts.PieChart(
                _seriesGenderPieData,
                animate: true,
                animationDuration: Duration(seconds: 1),
                behaviors: [
                  new charts.DatumLegend(
                    outsideJustification:
                        charts.OutsideJustification.startDrawArea,
                    horizontalFirst: true,
                    desiredMaxRows: 1,
                    cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                    entryTextStyle: charts.TextStyleSpec(
                      color: charts.MaterialPalette.purple.shadeDefault,
                      fontFamily: 'Georgia',
                      fontSize: 11,
                    ),
                  ),
                ],
                defaultRenderer: new charts.ArcRendererConfig(
                  arcWidth: getHeight(50, 2).toInt(),
                  arcRendererDecorators: [
                    new charts.ArcLabelDecorator(
                        labelPosition: charts.ArcLabelPosition.inside),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: getHeight(24, 2),
            ),
            Container(
              height: getHeight(200, 2),
              child: charts.PieChart(
                _seriesSAndBPieData,
                animate: true,
                animationDuration: Duration(seconds: 1),
                behaviors: [
                  new charts.DatumLegend(
                    outsideJustification:
                        charts.OutsideJustification.startDrawArea,
                    horizontalFirst: true,
                    desiredMaxRows: 1,
                    cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                    entryTextStyle: charts.TextStyleSpec(
                      color: charts.MaterialPalette.purple.shadeDefault,
                      fontFamily: 'Georgia',
                      fontSize: 11,
                    ),
                  ),
                ],
                defaultRenderer: new charts.ArcRendererConfig(
                  arcWidth: getHeight(50, 2).toInt(),
                  arcRendererDecorators: [
                    new charts.ArcLabelDecorator(
                        labelPosition: charts.ArcLabelPosition.inside),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getBody(int index){
    if(index==0){
      return membersItem(0xfff4c83f);
    }else if(index == 1){
      return eventsItem(0xffed622b);
    }else if(index==2){
      return dealsItem(0xff7297ff);
    }
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
              icon: Icon(
                Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                color: ColorGlobal.textColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'Business Dashboard',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: FutureBuilder(
          future: makeRequests(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
                print("no connection");
                return Center(child: NoInternetScreen(notifyParent: refresh));
              case ConnectionState.waiting:
              case ConnectionState.active:
                print("connection active");
                return Center(
                  child: SpinKitDoubleBounce(
                    color: ColorGlobal.blueColor,
                  ),
                );
              case ConnectionState.done:
                if(snapshot.hasError){
                  return _internet == true ? Center(child: Error8Screen()) : Center(child: NoInternetScreen(notifyParent: refresh));
                }else{
                  if(_hasError){
                    return Center(child: Error8Screen());
                  }
                  if(data.length == 0){
                    return Center(child: NodataScreen());
                  }
                  if(state<3){
                    return Center(child: SpinKitDoubleBounce(
                      color: ColorGlobal.blueColor,
                    ),
                    );
                  }
                  return StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index){
                      return getBody(index);
                    },
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                    crossAxisSpacing: getWidth(12, 2),
                    mainAxisSpacing: getHeight(12, 2),
                  );
                }

            }
            return Center(child: Text("Try Again!"));
          },
        ),
      ),
    );
  }
}

class Gender {
  String gender;
  int genderval;
  Color colorval;

  Gender(this.gender, this.genderval, this.colorval);
}

class SandB {
  String types;
  int typeval;
  Color colorval;

  SandB(this.types, this.typeval, this.colorval);
}
