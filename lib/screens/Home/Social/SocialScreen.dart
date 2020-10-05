import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iosrecal/constants/UIUtility.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:iosrecal/screens/Events/EventsScreen.dart';
import 'package:iosrecal/screens/Home/Social/pages/SocialNetworkList.dart';

class SocialScreen extends StatefulWidget {
  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
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
            'Social Group',
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
  List<String> options = List();
  List<AssetImage> images = List();
  UIUtility uiUtills = new UIUtility();

  @override
  void initState(){
    uiUtills = new UIUtility();
    Timer(Duration(milliseconds: 250), () {
      _foldingCellKey1?.currentState?.toggleFold();
      print("Yeah, this line is printed after 1 seconds");
    });
    Timer(Duration(milliseconds: 500), () {
      _foldingCellKey2?.currentState?.toggleFold();
      print("Yeah, this line is printed after 2 seconds");
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
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => MemberDatabase()));
    if(num==1)
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => EventsScreen(2)));
  }

  @override
  Widget build(BuildContext context) {
    options.add("Social Network List");
    options.add("Felicitations");

    images.add(AssetImage('assets/images/social_network_link.png'));
    images.add(AssetImage('assets/images/felicitation.png'));

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    uiUtills.updateScreenDimesion(width: width, height: height);

    return Container(
//      color: Color(0xFF2e282a),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: height/8 + 10.0,
          ),
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
