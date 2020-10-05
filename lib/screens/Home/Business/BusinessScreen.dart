import 'dart:async';
import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:iosrecal/screens/Home/Business/pages/BusinessNetworkList.dart';
import 'package:iosrecal/screens/Home/Business/pages/DealsExecuted.dart';
import 'pages/BusinessDashboard.dart';
import 'package:iosrecal/constants/UIUtility.dart';
import 'dart:io' show Platform;

class BusinessScreen extends StatefulWidget {
  @override
  _WaveHeaderState createState() => _WaveHeaderState();
}

class _WaveHeaderState extends State<BusinessScreen> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
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
            'Business Group',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: height,
            child: Center(
              child: FoldingCellMultipleCardsDemo(),
            ),
          ),
        ),
      ),
    );
  }
}

class FoldingCellMultipleCardsDemo extends StatefulWidget {
  @override
  _FoldingCellMultipleCardsDemoState createState() => _FoldingCellMultipleCardsDemoState();
}

class _FoldingCellMultipleCardsDemoState extends State<FoldingCellMultipleCardsDemo> {
  final _foldingCellKey1 = GlobalKey<SimpleFoldingCellState>();
  final _foldingCellKey2 = GlobalKey<SimpleFoldingCellState>();
  final _foldingCellKey3 = GlobalKey<SimpleFoldingCellState>();
  List<String> options = List();
  List<AssetImage> images = List();
  UIUtility uiUtills = new UIUtility();

  @override
  void initState(){
    uiUtills = new UIUtility();
    Timer(Duration(milliseconds: 250), () {
      _foldingCellKey1?.currentState?.toggleFold();
    });
    Timer(Duration(milliseconds: 500), () {
      _foldingCellKey2?.currentState?.toggleFold();
    });
    Timer(Duration(milliseconds: 750), () {
      _foldingCellKey3?.currentState?.toggleFold();
    });
  }

  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }

  void _navigatePage(int num){
    if(num==0)
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => DashBoard()));
    else if(num==1)
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => BusinessDatabase()));
    else
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => DealsExecuted()));
  }

  @override
  Widget build(BuildContext context) {

    options.add("Business Dashboard");
    options.add("Business Network List");
    options.add("Deals Executed");

    images.add(AssetImage('assets/images/dashboard.png'));
    images.add(AssetImage('assets/images/database.png'));
    images.add(AssetImage('assets/images/deals_executed.png'));
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    uiUtills.updateScreenDimesion(width: width, height: height);

    return Container(
      child: Column(
        children: <Widget>[
          SimpleFoldingCell.create(
            key: _foldingCellKey1,
            frontWidget: _buildFrontWidget(_foldingCellKey1, 0),
            innerWidget: _buildInnerWidget(_foldingCellKey1, 0),
            cellSize: Size(width, height/8),
            padding: EdgeInsets.all(15),
            animationDuration: Duration(milliseconds: 500),
            borderRadius: 10,
            onOpen: () => print('cell 1 opened'),
            onClose: () => print('cell 1 closed'),
          ),
          SimpleFoldingCell.create(
            key: _foldingCellKey2,
            frontWidget: _buildFrontWidget(_foldingCellKey2, 1),
            innerWidget: _buildInnerWidget(_foldingCellKey2, 1),
            cellSize: Size(width, height/8),
            padding: EdgeInsets.all(15),
            animationDuration: Duration(milliseconds: 500),
            borderRadius: 10,
            onOpen: () => print('cell 2 opened'),
            onClose: () => print('cell 2 closed'),
          ),
          SimpleFoldingCell.create(
            key: _foldingCellKey3,
            frontWidget: _buildFrontWidget(_foldingCellKey3, 2),
            innerWidget: _buildInnerWidget(_foldingCellKey3, 2),
            cellSize: Size(width, height/8),
            padding: EdgeInsets.all(15),
            animationDuration: Duration(milliseconds: 500),
            borderRadius: 10,
            onOpen: () => print('cell 3 opened'),
            onClose: () => print('cell 3 closed'),
          ),
        ],
      ),
    );
  }

  Widget _buildFrontWidget(
      GlobalKey<SimpleFoldingCellState> key, int num) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff374ABE), Color(0xff3AAFFA)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      alignment: Alignment.center,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              options[num],
              style: TextStyle(
                color: ColorGlobal.textColor,
                fontSize: getWidth(20, 2),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInnerWidget(GlobalKey<SimpleFoldingCellState> key, int num) {
    final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return new GestureDetector(
      onTap: (){
        _navigatePage(num);
      },
      child: Container(
        color: Color(0xFF9CD7FC),
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            SizedBox(
              width: width,
            ),
            Image(
              height: height/10 ,
              width: height/10 ,
              fit: BoxFit.cover,
              image:
              images[num],
            ),
            SizedBox(
              height: height/16,
            ),
            Text(
              options[num],
              style: TextStyle(
                color: ColorGlobal.textColor,
                fontSize: getWidth(22, 2),
                fontWeight: FontWeight.w600,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
