import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iosrecal/screens/Home/Arguments.dart';
import 'package:iosrecal/screens/Home/NoInternet.dart';
import 'package:iosrecal/screens/Home/errorWrong.dart';
import 'package:iosrecal/models/MemberModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:iosrecal/Constant/Constant.dart';
import 'package:iosrecal/screens/Home/errorWrong.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/EventModel.dart';
import 'package:iosrecal/models/BusinessMemberModel.dart';
import 'package:iosrecal/Endpoint/Api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';


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

  _fetchEvents() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
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
    print(response.statusCode);
    if (response.statusCode == 200) {
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      print(responseBody.status_code);
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

        setState(() {
          state += 1;
        });
      }else if(responseBody.status_code==401){
        onTimeOut();
      }else{
        setState(() {
          state+=1;
          _hasError = true;
        });
      }
    }else{
      setState(() {
        state+=1;
        _hasError = true;
      });
    }
  }

  Future<bool> onTimeOut(){
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Session Timeout'),
        content: new Text('Login to continue'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () async {
              //await _logoutUser();
              Navigator.pushReplacementNamed(context, LOGIN_SCREEN, arguments: TimeoutArguments(true));

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

  _fetchSpecificUsers() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http
        .get(
        Api.businessMembers, headers: {
      "Accept": "application/json",
      "Cookie": "${prefs.getString("cookie")}",
    });
    ResponseBody responseBody = new ResponseBody();
    print(response.statusCode);
    if (response.statusCode == 200) {
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      print(responseBody.status_code);
      if (responseBody.status_code == 200) {
        List list = responseBody.data;
        members = list.map((model) => BusinessMemberModel.fromJson(model)).toList();
        int dealValue=0;
        List names = List<String>();
        members.forEach((element) {
          dealValue += int.parse(element.deal_value);
          if(!names.contains(element.name)){
            final_members.add(element);
            names.add(element.name);
          }

        });
        data['Business Members'] = final_members.length;
        data['Social Members'] = data['All Members'] - final_members.length;
        data['All Deals'] = members.length;
        data['Deals Value'] = dealValue;
        _generatePieData();

        setState(() {
          state += 1;
        });

      }else{
        setState(() {
          state+=1;
          _hasError = true;
        });
      }
    }else{
      setState(() {
        state+=1;
        _hasError = true;
      });
    }
  }

  _fetchAllUsers() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http
        .get(
        Api.allUsers, headers: {
      "Accept": "application/json",
      "Cookie": "${prefs.getString("cookie")}",
    });
    ResponseBody responseBody = new ResponseBody();
    print(response.statusCode);
    if (response.statusCode == 200) {
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      print(responseBody.status_code);
      if (responseBody.status_code == 200) {
        List list = responseBody.data;
        users = list.map((model) => MemberModel.fromJson(model)).toList();
        data['All Members'] = users.length;
        int male = 0;
        users.forEach((element) {
          if(element.gender=="male"){
            print(element.name);
            male++;
          }

        });
        data['Male'] = male;
        data['Female'] = users.length - male;
        print("values are ");
        print(data['Male']);
        print(data['Female']);
        _fetchSpecificUsers();

        setState(() {
          state += 1;
        });

        }else{
        setState(() {
          state+=1;
          _hasError = true;
        });
      }
      }else{
      setState(() {
        state+=1;
        _hasError = true;
      });
    }
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
    setState(() {
      state+=1;
    });
  }

  @override
  void initState() {
    super.initState();
    _seriesGenderPieData = List<charts.Series<Gender, String>>();
    _seriesSAndBPieData = List<charts.Series<SandB, String>>();
    _fetchEvents();
    _fetchAllUsers();
    //_generatePieData();
  }

  Material myItems(IconData icon, String heading, int color) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        heading,
                        style: TextStyle(
                          color: new Color(color),
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: new Color(color),
                    borderRadius: BorderRadius.circular(24.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 30.0,
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
      borderRadius: BorderRadius.circular(24.0),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
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
                      Text(data['All Deals'].toString(), style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w700, fontSize: 34.0)),
                      SizedBox(
                        height: 24.0,
                      ),
                      Text('Total value', style: TextStyle(color: Color(color))),
                      Text(data['Deals Value'].toString(), style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w700, fontSize: 34.0)),
                    ],
                  ),
                  Material(
                      color: Color(color),
                      borderRadius: BorderRadius.circular(24.0),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image(
                          image: AssetImage('assets/images/deals.png'),
                          height: 30.0,
                          width: 30.0,
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
      borderRadius: BorderRadius.circular(24.0),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
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
                      Text(data['All Events'].toString(), style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w700, fontSize: 34.0)),
                    ],
                  ),
                  Material(
                      color: Color(color),
                      borderRadius: BorderRadius.circular(24.0),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image(
                          image: AssetImage('assets/images/events.png'),
                          height: 30.0,
                          width: 30.0,
                        ),
                      )))
                ]),
            SizedBox(
              height: 24.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Image(
                      image: AssetImage('assets/images/social_db.png'),
                      height: 30.0,
                      width: 30.0,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                        data['Social Events'].toString(),
                        style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w400, fontSize: 22.0)
                    ),
                  ],
                ),
                Column(
                  children: [
                    Image.asset(
                      'assets/images/business_db.png',
                      height: 30.0,
                      width: 30.0,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                        data['Business Events'].toString(),
                        style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w400, fontSize: 22.0)
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
      borderRadius: BorderRadius.circular(24.0),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
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
                      Text('Total members', style: TextStyle(color: Color(color))),
                      Text(data['All Members'].toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 34.0)),
                    ],
                  ),
                  Material(
                      color: Color(color),
                      borderRadius: BorderRadius.circular(24.0),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child:
                            Icon(Icons.group, color: Colors.white, size: 30.0),
                      )))
                ]),
            SizedBox(
              height: 24.0,
            ),
            Expanded(
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
                  arcWidth: 50,
                  arcRendererDecorators: [
                    new charts.ArcLabelDecorator(
                        labelPosition: charts.ArcLabelPosition.inside),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Expanded(
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
                  arcWidth: 50,
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

  Widget getBody(){
    if(!_internet){
      return Center(child: NoInternetScreen());
    }
    if(_hasError){
      return Center(
        child: Error8Screen(),
      );
    }
    if(state<3){
      return Center(
        child: SpinKitDoubleBounce(
          color: Colors.lightBlueAccent,
        ),
      );
    }
    return new StaggeredGridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: <Widget>[
        membersItem(0xfff4c83f),
        eventsItem(0xffed622b),
        dealsItem(0xff7297ff),
      ],
      staggeredTiles: [
        StaggeredTile.extent(2, 550.0),
        StaggeredTile.extent(2, 206.0),
        StaggeredTile.extent(2, 204.0),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorGlobal.whiteColor,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: ColorGlobal.textColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'Business DashBoard',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: getBody(),
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
