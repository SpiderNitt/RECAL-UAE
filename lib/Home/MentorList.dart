import 'package:flutter/material.dart';

void main() => runApp(MentorList());

class MentorList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return  SafeArea(
      child: Scaffold(
//          backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text('Employment Support'),
                backgroundColor: const Color(0xFF3AAFFA),

              ),
              body: Column(
                children: <Widget>[
//              Container(
//                height: 250.0,
//                width: width,
//                child: Image.asset('assets/images/employment_groups.jpg', fit: BoxFit.cover),
//              ),
                  Container(
//                transform: Matrix4.translationValues(0.0, -230.0, 0.0),
                    child: Hero(
                      tag: 'textHero0',
                      child: Text(
                        'IT and Related Services',
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Padding(padding: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Text(
                                      'Item 1',
                                      style: new TextStyle(fontSize: 18.0)
                                  ),
                                  Container(
                                    height: 30.0,
                                    width: 30.0,
                                    child: IconButton(
                                        icon: Icon(Icons.arrow_forward_ios,
                                          color: Color(0x88000000),
                                        ),
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/mentorList');
                                          // Do something
                                        }
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              const Divider(
                                color: const Color(0x22000000),
                                height: 1,
                                thickness: 1,
                              ),
                            ],
                          )
                      ),
                      Padding(padding: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Text(
                                      'Item 2',
                                      style: new TextStyle(fontSize: 18.0)
                                  ),
                                  Container(
                                    height: 30.0,
                                    width: 30.0,
                                    child: IconButton(
                                        icon: Icon(Icons.arrow_forward_ios,
                                          color: Color(0x88000000),
                                        ),
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/mentorList');
                                          // Do something
                                        }
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              const Divider(
                                color: const Color(0x22000000),
                                height: 1,
                                thickness: 1,
                              ),
                            ],
                          )
                      ),
                      Padding(padding: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Text(
                                      'Item 3',
                                      style: new TextStyle(fontSize: 18.0)
                                  ),
                                  Container(
                                    height: 30.0,
                                    width: 30.0,
                                    child: IconButton(
                                        icon: Icon(Icons.arrow_forward_ios,
                                          color: Color(0x88000000),
                                        ),
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/mentorList');
                                          // Do something
                                        }
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              const Divider(
                                color: const Color(0x22000000),
                                height: 1,
                                thickness: 1,
                              ),
                            ],
                          )
                      ),
                    ],
                  )
                ],
              )
          ),
    );
  }}