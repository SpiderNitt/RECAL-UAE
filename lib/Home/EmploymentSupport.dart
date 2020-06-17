import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import '../Constant/Constant.dart';

//void main() => runApp(new MySliverApp());
//
//class MySliverApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      home: new EmploymentSupport(),
//    );
//  }
//}

class EmploymentSupport extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<EmploymentSupport> {
  //   with SingleTickerProviderStateMixin {
  // Animation animation1,
  //     animation2,
  //     animation3,
  //     animation4,
  //     animation5,
  //     animation6,
  //     animation7,
  //     animation8,
  //     animation9,
  //     animation10;
  // AnimationController animationController;

  // @override
  // void initState() {
  //   super.initState();
  //   animationController =
  //       AnimationController(duration: Duration(seconds: 5), vsync: this);

  //   animation1 = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
  //       parent: animationController, curve: Curves.fastOutSlowIn));

  //   animation2 = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
  //       parent: animationController,
  //       curve: Interval(0.1, 1.0, curve: Curves.fastOutSlowIn)));

  //   animation3 = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
  //       parent: animationController,
  //       curve: Interval(0.2, 1.0, curve: Curves.fastOutSlowIn)));

  //   animation4 = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
  //       parent: animationController,
  //       curve: Interval(0.3, 1.0, curve: Curves.fastOutSlowIn)));

  //   animation5 = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
  //       parent: animationController,
  //       curve: Interval(0.4, 1.0, curve: Curves.fastOutSlowIn)));

  //   animation6 = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
  //       parent: animationController,
  //       curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn)));

  //   animation7 = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
  //       parent: animationController,
  //       curve: Interval(0.6, 1.0, curve: Curves.fastOutSlowIn)));

  //   animation8 = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
  //       parent: animationController,
  //       curve: Interval(0.7, 1.0, curve: Curves.fastOutSlowIn)));

  //   animation9 = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
  //       parent: animationController,
  //       curve: Interval(0.8, 1.0, curve: Curves.fastOutSlowIn)));

  //   animation10 = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
  //       parent: animationController,
  //       curve: Interval(0.9, 1.0, curve: Curves.fastOutSlowIn)));
  // }

  //animationController.forward();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                ),
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text("Employment Groups",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        )),
                    background: Image.asset(
                      "assets/images/employment_groups.jpg",
                      fit: BoxFit.cover,
                    )),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
              child: new Column(
                children: <Widget>[
                  SizedBox(height: 15.0, width: width,),
                  Container(
                    height: 80.0,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sliverAppBar');
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Color(0xff374ABE), Color(0xff3AAFFA)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: width, minHeight: 80.0),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
//                                    alignment: Alignment.centerRight,
                                  child: Image(
                                    height: 40.0,
                                    width: 40.0,
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/images/curriculum.png'),
                                    alignment: Alignment.bottomCenter,
                                  ),
                                ),
                                Container(
//                                    alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Upload CV",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: 80.0,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sliverAppBar');
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Color(0xff374ABE), Color(0xff3AAFFA)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: width, minHeight: 80.0),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
//                                    alignment: Alignment.centerRight,
                                  child: Image(
                                    height: 40.0,
                                    width: 40.0,
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/images/open_positions.png'),
                                    alignment: Alignment.bottomCenter,
                                  ),
                                ),
                                Container(
//                                    alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Positions",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: 80.0,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sliverAppBar');
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Color(0xff374ABE), Color(0xff3AAFFA)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: width, minHeight: 80.0),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
//                                    alignment: Alignment.centerRight,
                                  child: Image(
                                    height: 40.0,
                                    width: 40.0,
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/images/upload_positions.png'),
                                    alignment: Alignment.bottomCenter,
                                  ),
                                ),
                                Container(
//                                    alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Upload Positions",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: 80.0,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sliverAppBar');
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Color(0xff374ABE), Color(0xff3AAFFA)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: width, minHeight: 80.0),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
//                                    alignment: Alignment.centerRight,
                                  child: Image(
                                    height: 40.0,
                                    width: 40.0,
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/images/alumni_placed.png'),
                                    alignment: Alignment.bottomCenter,
                                  ),
                                ),
                                Container(
//                                    alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Alumni Placed",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: 80.0,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sliverAppBar');
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Color(0xff374ABE), Color(0xff3AAFFA)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: width, minHeight: 80.0),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
//                                    alignment: Alignment.centerRight,
                                  child: Image(
                                    height: 40.0,
                                    width: 40.0,
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/images/seek_guidance.png'),
                                    alignment: Alignment.bottomCenter,
                                  ),
                                ),
                                Container(
//                                    alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Seek Guidance",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: 80.0,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, MEMBER_LINKEDIN);
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Color(0xff374ABE), Color(0xff3AAFFA)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: width, minHeight: 80.0),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
//                                    alignment: Alignment.centerRight,
                                  child: Image(
                                    height: 30.0,
                                    width: 30.0,
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/images/member_linkedin.png'),
                                    alignment: Alignment.bottomCenter,
                                  ),
                                ),
                                Container(
//                                    alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Member LinkedIn",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: 80.0,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sliverAppBar');
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Color(0xff374ABE), Color(0xff3AAFFA)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: width, minHeight: 80.0),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
//                                    alignment: Alignment.centerRight,
                                  child: Image(
                                    height: 30.0,
                                    width: 30.0,
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/images/resume_writing.png'),
                                    alignment: Alignment.bottomCenter,
                                  ),
                                ),
                                Container(
//                                    alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Resume Writing",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: 80.0,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sliverAppBar');
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Color(0xff374ABE), Color(0xff3AAFFA)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: width, minHeight: 80.0),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
//                                    alignment: Alignment.centerRight,
                                  child: Image(
                                    height: 40.0,
                                    width: 40.0,
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/images/market_survey.png'),
                                    alignment: Alignment.bottomCenter,
                                  ),
                                ),
                                Container(
//                                    alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Market Survey",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: 80.0,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sliverAppBar');
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Color(0xff374ABE), Color(0xff3AAFFA)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: width, minHeight: 80.0),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
//                                    alignment: Alignment.centerRight,
                                  child: Image(
                                    height: 30.0,
                                    width: 30.0,
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/images/write_to_admin.png'),
                                    alignment: Alignment.bottomCenter,
                                  ),
                                ),
                                Container(
//                                    alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Write to Admin",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          )),
    );
  }
}