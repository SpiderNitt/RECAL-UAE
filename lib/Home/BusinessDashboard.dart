import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import './MemberDatabase.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../Constant/ColorGlobal.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  List<charts.Series<Gender, String>> _seriesGenderPieData;
  List<charts.Series<SandB, String>> _seriesSAndBPieData;

  _generatePieData(){
    var genderPieData =[
      new Gender('Male', 165, Color(0xcc3399fe)),
      new Gender('Female', 100, Color(0xccff3266)),
    ];

    var sAndBPieData =[
      new SandB('Social', 197, Color(0xcc982ef0)),
      new SandB('Business', 68, Color(0xcc26cb3c)),
    ];

    _seriesGenderPieData.add(
      charts.Series(
        data: genderPieData,
        domainFn: (Gender gender, _) => gender.gender,
        measureFn: (Gender gender, _) => gender.genderval,
        colorFn: (Gender gender, _) =>
          charts.ColorUtil.fromDartColor(gender.colorval),
        id: 'Gender distribution',
        labelAccessorFn: (Gender row, _)=>'${row.gender}',

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
        labelAccessorFn: (SandB row, _)=>'${row.types}',

      ),
    );
  }

  @override
  void initState(){
    super.initState();
    _seriesGenderPieData = List<charts.Series<Gender, String>>();
    _seriesSAndBPieData = List<charts.Series<SandB, String>>();
    _generatePieData();
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

  Material dealsItem(int color){
    return Material(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>
                [
                  Column
                    (
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>
                    [
                      Text('Total deals', style: TextStyle(color: Color(color))),
                      Text('17', style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w700, fontSize: 34.0)),
                      SizedBox(
                        height: 24.0,
                      ),
                      Text('Total value', style: TextStyle(color: Color(color))),
                      Text('13689', style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w700, fontSize: 34.0)),
                    ],
                  ),
                  Material
                    (
                      color: Color(color),
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
                  )
                ]
            ),
          ],
        ),
      ),
    );
  }

  Material eventsItem(int color){
    return Material(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>
                [
                  Column
                    (
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>
                    [
                      Text('Total events', style: TextStyle(color: Color(color))),
                      Text('53', style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w700, fontSize: 34.0))
                    ],
                  ),
                  Material
                    (
                      color: Color(color),
                      borderRadius: BorderRadius.circular(24.0),
                      child: Center
                        (
                          child: Padding
                            (
                            padding: const EdgeInsets.all(16.0),
                            child: Image(
                              image: AssetImage('assets/images/events.png'),
                              height: 30.0,
                              width: 30.0,
                            ),
                          )
                      )
                  )
                ]
            ),
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
                      '37',
                        style: TextStyle(color: ColorGlobal.textColor, fontWeight: FontWeight.w400, fontSize: 22.0)
                    ),
                  ],
                ),
                Column(
                  children: [
                    Image.asset('assets/images/business_db.png', height: 30.0, width: 30.0,),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                        '16',
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
      child: Padding
        (
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row
              (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>
                [
                  Column
                    (
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>
                    [
                      Text('Total members', style: TextStyle(color: Color(color))),
                      Text('265', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 34.0))
                    ],
                  ),
                  Material
                    (
                      color: Color(color),
                      borderRadius: BorderRadius.circular(24.0),
                      child: Center
                        (
                          child: Padding
                            (
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.group, color: Colors.white, size: 30.0),
                          )
                      )
                  )
                ]
            ),
            SizedBox(
              height: 24.0,
            ),
            Expanded(
              child: charts.PieChart(
                _seriesGenderPieData,
                animate: true,
                animationDuration: Duration(seconds : 1),
                behaviors: [
                  new charts.DatumLegend(
                    outsideJustification: charts.OutsideJustification.startDrawArea,
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
                      labelPosition: charts.ArcLabelPosition.inside
                    ),
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
                animationDuration: Duration(seconds : 1),
                behaviors: [
                  new charts.DatumLegend(
                    outsideJustification: charts.OutsideJustification.startDrawArea,
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
                        labelPosition: charts.ArcLabelPosition.inside
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
        body: new StaggeredGridView.count(
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
            StaggeredTile.extent(2, 198.0),
            StaggeredTile.extent(2, 190.0),

          ],
        ),
      ),
    );
  }
}

class Gender{
  String gender;
  int genderval;
  Color colorval;

    Gender(this.gender, this.genderval, this.colorval);
}

class SandB{
  String types;
  int typeval;
  Color colorval;

  SandB(this.types, this.typeval, this.colorval);
}



