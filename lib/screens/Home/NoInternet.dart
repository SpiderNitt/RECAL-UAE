import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

class NoInternetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: height / 1.35,
                    child: PageView(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: height / 9,
                              ),
                              Center(
                                child: FadeIn(
                                  child: Text(
                                    "NOT CONNECTED TO INTERNET",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xff3AAFFA)),
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: Duration(milliseconds: 2000),
                                  curve: Curves.easeIn,
                                ),
                              ),
                              SizedBox(
                                height: height / 100,
                              ),
                              Center(
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/no_internet.jpg',
                                  ),
                                  height: height / 2.5,
                                  fit: BoxFit.fill,
                                  //width: width / 1.5,
                                ),
                              ),
                              //SizedBox(height: 12.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
