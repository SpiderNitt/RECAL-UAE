import 'package:flutter/material.dart';
import '../Constant/ColorGlobal.dart';

class CoreComm extends StatefulWidget {
  @override
  CoreCommState createState() {
    return new CoreCommState();
  }
}

class CoreCommState extends State<CoreComm> {
  var top = FractionalOffset.topCenter;
  var bottom = FractionalOffset.bottomCenter;
  double width = 220.0;
  double widthIcon = 200.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Core Committee");
  }

  Future<bool> _onBackPressed() {
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    final refHeight = 700.666;
    final refWidth = 360;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child:
      SafeArea(
        child:
        Scaffold(
            appBar: AppBar(
              backgroundColor: ColorGlobal.whiteColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: ColorGlobal.textColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'Core Committee',
                style: TextStyle(color: ColorGlobal.textColor),
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                        colors: [
                          Color(0xFFDAD8D9),
                          Color(0xFFD9C8C0).withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFEAE3E3),
                          spreadRadius: 2,
                          blurRadius: 0,
                          // changes position of shadow
                        ),
                      ],
                      border: Border.all(
                        width: 2,
                        color: Color(0xFF544F50), //                   <--- border width here
                      ),
                      color: Color(0xFF544F50),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          (22.0),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "The ongoing members of the core committee of RECAL UAE Chapter are functioning since Oct 2019. The member details are as follows:"
                            "\n\nPresident:\n ASHEET AGARWAL (Arch. 1994)"
                            "\n\nVice President:\n MANOJ PANDEY (Chem. 1994)"
                            "\n\nSecretary:\n NAVAL TAYDE (EEE. 2004)"
                            "\n\nJoint Secretary:\n LIMI SURESH (Arch. 2017)"
                            "\n\nTreasurer:\n UMESH AGARWAL (Arch. 1999)"
                            "\n\nMentor 1:\n ANAMITRA ROY (Meta. 1989)"
                            "\n\nMentor 2:\n GANGA KANDASWAMY (CSE. 1987)"
                        ,
                        style: TextStyle(
                          color: Color(0xFF544F50),
                          fontSize: 15.0*(size.width)/refWidth,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                ),
              ),
            )
        ),
      ),
    );
  }
}