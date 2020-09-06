import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iosrecal/Home/errorWrong.dart';
import 'package:iosrecal/Home/NoData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/BusinessMemberModel.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant/ColorGlobal.dart';

class DealsExecuted extends StatefulWidget {
  @override
  _DealsExecutedState createState() => _DealsExecutedState();
}

class _DealsExecutedState extends State<DealsExecuted> {
  var members = new List<BusinessMemberModel>();
  bool _hasError = false;

  initState() {
    super.initState();
//    _positions();
  }

  Future<List> _positions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http
        .get("https://delta.nitt.edu/recal-uae/api/business/members/", headers: {
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

      }else{
        _hasError = true;
      }
    }else{
      _hasError = true;
    }
    return members;
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
            'Deals Executed',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: Center(
          child: FutureBuilder(
            future: _positions(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.none:
                  return Center(child: Error8Screen());
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
                    return Center(child: Error8Screen());
                  }else{
                    print(members.length);
                    if(members.length == 0){
                      return Center(child: NodataScreen());
                    }
                    return StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      itemCount: members.length,
                      itemBuilder: (BuildContext context, int index){
                        print("right here");
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Material(
                            color: Colors.white,
                            elevation: 14.0,
                            shadowColor: Color(0x802196F3),
                            borderRadius: BorderRadius.circular(24.0),
                            child: Padding
                              (
                              padding: const EdgeInsets.all(24.0),
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
                                            borderRadius: BorderRadius.circular(24.0),
                                            child: Center
                                              (
                                                child: Padding
                                                  (
                                                  padding: const EdgeInsets.all(16.0),
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 30.0,
                                                    color: Colors.white,
                                                  ),
                                                )
                                            )
                                        ),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Column
                                          (
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>
                                          [
                                            Text('Name', style: TextStyle(color: Color(0xfff4c83f), fontSize: 13.0)),
                                            Text(members[index].name, style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w700, fontSize: 20.0))
                                          ],
                                        ),
                                      ]
                                  ),
                                  SizedBox(
                                    height: 24.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Material(
                                            color: Color(0xcced622b),
                                            borderRadius: BorderRadius.circular(24.0),
                                            child: Center
                                              (
                                              child: Padding
                                                (
                                                padding: const EdgeInsets.all(16.0),
                                                child: Icon(
                                                  Icons.business,
                                                  size: 30.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          Column
                                            (
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>
                                            [
                                              Text('Industry', style: TextStyle(color: Color(0xffed622b), fontSize: 13.0)),
                                              Text(members[index].industry, style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w700, fontSize: 20.0))
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Column
                                            (
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>
                                            [
                                              Text('Business Type', style: TextStyle(color: Color(0xffed622b), fontSize: 13.0)),
                                              Text(members[index].business_type, style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w700, fontSize: 20.0))
                                            ],
                                          ),
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          Material(
                                            color: Color(0xcced622b),
                                            borderRadius: BorderRadius.circular(24.0),
                                            child: Center
                                              (
                                              child: Padding
                                                (
                                                padding: const EdgeInsets.all(16.0),
                                                child: Icon(
                                                  Icons.business_center,
                                                  size: 30.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: 24.0
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Material(
                                        color: Color(0xcc26cb3c),
                                        borderRadius: BorderRadius.circular(24.0),
                                        child: Center
                                          (
                                          child: Padding
                                            (
                                            padding: const EdgeInsets.all(16.0),
                                            child: Icon(
                                              Icons.assignment,
                                              size: 30.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Column
                                        (
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>
                                        [
                                          Text('Company Brief', style: TextStyle(color: Color(0xcc26cb3c), fontSize: 13.0)),
                                          Text(members[index].company_brief, style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w400, fontSize: 20.0))
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 24.0,
                                  ),
                                  Column(
                                    children: [
                                      Row
                                        (
                                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>
                                          [
                                            Material
                                              (
                                                color: Color(0xcc982ef0),
                                                borderRadius: BorderRadius.circular(24.0),
                                                child: Center
                                                  (
                                                    child: Padding
                                                      (
                                                      padding: const EdgeInsets.all(16.0),
                                                      child: Image(
                                                        image: AssetImage('assets/images/deals.png'),
                                                        height: 30.0,
                                                        width: 30.0,
                                                      ),
                                                    )
                                                )
                                            ),
                                            SizedBox(
                                              width: 8.0,
                                            ),
                                            Column
                                              (
                                              //mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>
                                              [
                                                Text('Deal Value', style: TextStyle(color: Color(0xcc982ef0), fontSize: 13.0)),
                                                Text(members[index].deal_value, style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w700, fontSize: 20.0)),
                                                SizedBox(
                                                  height: 24.0,
                                                ),
                                                Text('Deal Details', style: TextStyle(color: Color(0xcc982ef0), fontSize: 13.0)),
                                                Text(members[index].deal_details, style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w400, fontSize: 20.0)),
                                              ],
                                            ),
                                          ]
                                      ),
                                    ],
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
