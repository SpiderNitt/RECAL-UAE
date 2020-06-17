import 'package:flutter/material.dart';


class SurveyScreen extends StatefulWidget {
  @override
  SurveyScreenState createState() => new SurveyScreenState();
}

class SurveyScreenState extends State<SurveyScreen> {

  Future<bool> _onBackPressed () {
   Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
        appBar: AppBar(
          title: Text('Market Survey'),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
             Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.fromLTRB(20.0, height / 7, 20, 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            "Your opinion matters!!",
                            style: TextStyle(
                                fontSize: 25,
                                color: const Color(0xff3AAFFA),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            "Click the button below to fill in the market survey.",
                            style: TextStyle(
                              fontSize: 15,
                              color: const Color(0xff3AAFFA),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            width: width / 2,
                            height: 40,
                            child: RaisedButton(
                              onPressed: () {},
                              color: const Color(0xff3AAFFA),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      "Go to survey",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  Container(
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 30.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Image(
                      height: height / 2,
                      width: width,
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/MarketSurvey.jpg'),
                      alignment: Alignment.bottomCenter,
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
