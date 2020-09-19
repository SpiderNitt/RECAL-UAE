import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iosrecal/Constant/Constant.dart';
import 'package:iosrecal/screens/Home/NoInternet.dart';
import 'package:iosrecal/screens/Home/errorWrong.dart';
import 'package:iosrecal/screens/Home/NoData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/BusinessMemberModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:iosrecal/Endpoint/Api.dart';
import 'package:connectivity/connectivity.dart';


class DealsExecuted extends StatefulWidget {
  @override
  _DealsExecutedState createState() => _DealsExecutedState();
}

class _DealsExecutedState extends State<DealsExecuted> {
  var members = new List<BusinessMemberModel>();
  bool _hasError = false;
  int internet = 1;

  initState() {
    super.initState();
  }

  Future<List> _deals() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      internet = 0;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http
        .get(Api.businessMembers, headers: {
      "Accept": "application/json",
      "Cookie": "${prefs.getString("cookie")}",
    });
    ResponseBody responseBody = new ResponseBody();
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("success");
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      if (responseBody.status_code == 200) {

          List list = responseBody.data;
          members = list.map((model) => BusinessMemberModel.fromJson(model)).toList();
          print('heys');
          //print(positions.length);

      }else if(responseBody.status_code==401){
        onTimeOut();
      }else{
        _hasError = true;
      }
    }else{
      _hasError = true;
    }
    return members;
  }

  navigateAndReload(){
    Navigator.pushNamed(context, LOGIN_SCREEN, arguments: true)
        .then((value) {
      Navigator.pop(context);
      setState(() {

      });
      _deals();
    });
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

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
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
            'Deals Executed',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: Center(
          child: FutureBuilder(
            future: _deals(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.none:
                  return Center(child: NoInternetScreen());
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return Center(
                    child: SpinKitDoubleBounce(
                      color: Colors
                          .lightBlueAccent,
                    ),
                  );
                case ConnectionState.done:
                  print("done");
                  if(snapshot.hasError){
                    print("error");
                    return internet == 1 ? Center(child: Error8Screen()) : Center(child: NoInternetScreen());
                  }else{
                    print(members.length);
                    if(_hasError){
                      return Center(child: Error8Screen());
                    }
                    if(members.length == 0){
                      return Center(child: NodataScreen());
                    }
                    return StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      itemCount: members.length,
                      itemBuilder: (BuildContext context, int index){
                        print("right here");
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: width/25, vertical: width/50),
                          child: Material(
                            color: Colors.white,
                            elevation: 14.0,
                            shadowColor: Color(0x802196F3),
                            borderRadius: BorderRadius.circular(3*width/50),
                            child: Padding
                              (
                              padding: EdgeInsets.all(3*width/50),
                              child: Column(
                                children: [
                                  Row
                                    (
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>
                                      [
                                        Material
                                          (
                                            color: Color(0xfff4c83f),
                                            borderRadius: BorderRadius.circular(3*width/50),
                                            child: Center
                                              (
                                                child: Padding
                                                  (
                                                  padding: EdgeInsets.all(width/25),
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 7*width/100,
                                                    color: Colors.white,
                                                  ),
                                                )
                                            )
                                        ),
                                        SizedBox(
                                          width: width/50,
                                        ),
                                        Container(
                                          width: 63*width/100,
                                          child: Column
                                            (
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>
                                            [
                                              AutoSizeText('Name', style: TextStyle(color: Color(0xfff4c83f), fontSize: 13.0), maxLines: 1,),
                                              AutoSizeText(members[index].name, style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w500, fontSize: 20.0), maxLines: 1,)
                                            ],
                                          ),
                                        ),
                                      ]
                                  ),
                                  SizedBox(
                                    height: 3*width/50,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Material(
                                        color: Color(0xffed622b),
                                        borderRadius: BorderRadius.circular(3*width/50),
                                        child: Center
                                          (
                                          child: Padding
                                            (
                                            padding: EdgeInsets.all(width/25),
                                            child: Icon(
                                              Icons.business,
                                              size: 7*width/100,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/50,
                                      ),
                                      Container(
                                        width: 63*width/100,
                                        child: Column
                                          (
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>
                                          [
                                            AutoSizeText('Industry', style: TextStyle(color: Color(0xffed622b), fontSize: 13.0), maxLines: 1,),
                                            AutoSizeText(members[index].industry, style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w500, fontSize: 20.0), maxLines: 5,)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 3*width/50,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Material(
                                        color: Color(0xcc26cb3c),
                                        borderRadius: BorderRadius.circular(3*width/50),
                                        child: Center
                                          (
                                          child: Padding
                                            (
                                            padding: EdgeInsets.all(width/25),
                                            child: Icon(
                                              Icons.business_center,
                                              size: 7*width/100,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/50,
                                      ),
                                      Container(
                                        width: 63*width/100,
                                        child: Column
                                          (
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>
                                          [
                                            AutoSizeText('Business Type', style: TextStyle(color: Color(0xcc26cb3c), fontSize: 13.0), maxLines: 1,),
                                            AutoSizeText(members[index].business_type, style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w500, fontSize: 20.0), maxLines: 5,)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: 3*width/50,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Material(
                                        color: Color(0xccff3266),
                                        borderRadius: BorderRadius.circular(3*width/50),
                                        child: Center
                                          (
                                          child: Padding
                                            (
                                            padding: EdgeInsets.all(width/25),
                                            child: Icon(
                                              Icons.assignment,
                                              size: 7*width/100,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/50,
                                      ),
                                      Container(
                                        width: 63*width/100,
                                        child: Column
                                          (
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>
                                          [
                                            AutoSizeText('Company Brief', style: TextStyle(color: Color(0xccff3266), fontSize: 13.0), maxLines: 1,),
                                            AutoSizeText(members[index].company_brief, style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w500, fontSize: 20.0), maxLines: 5,)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 3*width/50,
                                  ),
                                  Row
                                    (
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>
                                      [
                                        Material
                                          (
                                            color: Color(0xcc982ef0),
                                            borderRadius: BorderRadius.circular(3*width/50),
                                            child: Center
                                              (
                                                child: Padding
                                                  (
                                                  padding: EdgeInsets.all(width/25),
                                                  child: Image(
                                                    image: AssetImage('assets/images/deals.png'),
                                                    height: 7*width/100,
                                                    width: 7*width/100,
                                                  ),
                                                )
                                            )
                                        ),
                                        SizedBox(
                                          width: width/50,
                                        ),
                                        Container(
                                          width: 63*width/100,
                                          child: Column
                                            (
                                            //mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>
                                            [
                                              AutoSizeText('Deal Value', style: TextStyle(color: Color(0xcc982ef0), fontSize: 13.0), maxLines: 1,),
                                              AutoSizeText(members[index].deal_value, style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w500, fontSize: 20.0), maxLines: 1,),
                                              SizedBox(
                                                height: 3*width/50,
                                              ),
                                              AutoSizeText('Deal Details', style: TextStyle(color: Color(0xcc982ef0), fontSize: 13.0), maxLines: 5,),
                                              AutoSizeText(members[index].deal_details, style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w500, fontSize: 20.0), maxLines: 1,),
                                            ],
                                          ),
                                        ),
                                      ]
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                    );
                  }

              };
              return Center(child: Text("Try Again!"));
            },
          ),
        ),
      ),
    );
  }
}
