import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/ResponseBody.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant/Constant.dart';
import '../Constant/ColorGlobal.dart';
import 'package:badges/badges.dart';
import 'EditProfile.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _unfinished = 2;
  Future<dynamic> user;
  String cookie = "";

  Future<dynamic> _fetchPrimaryDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name =
        prefs.getString("name") == null ? "+9,q" : prefs.getString("name");
    String email =
        prefs.getString("email") == null ? "+9,q" : prefs.getString("email");
    String cookie_1 =
        prefs.getString("cookie") == null ? "+9,q" : prefs.getString("cookie");
    setState(() {
      cookie = cookie_1;
    });
    return {"name": name, "email": email};
  }

  _logoutDialog(String show, String again, int flag) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: Text('Logout Check'),
            content: new Text(show),
            actions: <Widget>[
              new GestureDetector(
                onTap: () {
                  flag != 1
                      ? Navigator.of(context).pop(false)
                      : Navigator.pushReplacementNamed(context, HOME_PAGE);
                },
                child: FlatButton(
                  color: Colors.green,
                  child: Text(again),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  _deleteUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", null);
    prefs.setString("name", null);
    prefs.setInt("user_id", null);
    prefs.setString("cookie", null);
  }

  Future<bool> _onLogoutPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to Logout?'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: FlatButton(
                  color: Colors.green,
                  child: Text("NO"),
                ),
              ),
              new GestureDetector(
                onTap: () async {
                  var url = "https://delta.nitt.edu/recal-uae/api/auth/logout/";
                  await http
                      .post(url, headers: {'Cookie': cookie}).then((_response) {
                      if (_response.statusCode == 200) {
                       ResponseBody responseBody =
                            ResponseBody.fromJson(json.decode(_response.body));

                        print(json.encode(responseBody.data));
                        if (responseBody.status_code == 200) {
                          _deleteUserDetails();
                          Navigator.pop(context,true);
                          Navigator.pushReplacementNamed(context, LOGIN_SCREEN);
                        }
                        else {
                          _deleteUserDetails();
                          print("${responseBody.data}");
                          SystemNavigator.pop();
                        }
                      }
                      else {
                        _deleteUserDetails();
                        print("Server error");
                        SystemNavigator.pop();
                      }
                  }).catchError((error) {
                    _deleteUserDetails();
                    print("server error");
                    SystemNavigator.pop();
                  });
                },
                child: FlatButton(
                  color: Colors.red,
                  child: Text("YES"),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = _fetchPrimaryDetails();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: ColorGlobal.whiteColor,
          appBar: AppBar(
            backgroundColor: ColorGlobal.whiteColor,
            actions: <Widget>[
              IconButton(
                padding: EdgeInsets.only(right: 20),
                icon: Icon(
                  Icons.exit_to_app,
                  size: 30,
                  color: ColorGlobal.textColor,
                ),
                onPressed: () {
                  _onLogoutPressed();
                },
              )
            ],
            title: Text(
              'Profile',
              style: TextStyle(color: ColorGlobal.textColor),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                      child: Hero(
                    tag: 'profile_pic',
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PictureScreen()));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        height: 160,
                        width: 160,
                        decoration: new BoxDecoration(
                          color: ColorGlobal.colorPrimaryDark,
                          image: new DecorationImage(
                            image:
                                new AssetImage('assets/images/spiderlogo.png'),
                            fit: BoxFit.contain,
                          ),
                          border: Border.all(
                              color: ColorGlobal.colorPrimaryDark, width: 2),
                          borderRadius:
                              new BorderRadius.all(const Radius.circular(80.0)),
                        ),
                      ),
                    ),
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      child: FutureBuilder<dynamic>(
                        future: user,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "${snapshot.data["name"]}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      letterSpacing: 1,
                                      color: ColorGlobal.textColor
                                          .withOpacity(0.9),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  child: Text(
                                    "${snapshot.data["email"]}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      letterSpacing: 1,
                                      color: ColorGlobal.textColor
                                          .withOpacity(0.6),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }
                          // By default, show a loading spinner.
                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Badge(
                      badgeColor: Colors.red,
                      position: BadgePosition.bottomRight(bottom: 27, right: 5),
                      shape: BadgeShape.circle,
                      borderRadius: 5,
                      toAnimate: true,
                      badgeContent: Text('$_unfinished'),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.downToUp,
                                  duration: Duration(milliseconds: 400),
                                  child: EditProfileScreen())).then((value) {
                                    setState(() {
                                      user=_fetchPrimaryDetails();
                                    });
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorGlobal.whiteColor,
                            border: Border.all(color: ColorGlobal.textColor),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Edit Profile",
                            style: TextStyle(
                                color: ColorGlobal.textColor,
                                fontWeight: FontWeight.bold),
                          ),
                          height: 27.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

// ignore: must_be_immutable
class PictureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'profile_pic',
            child: Container(
              width: 300,
              height: 300,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: new BoxDecoration(
                color: ColorGlobal.colorPrimaryDark,
                image: new DecorationImage(
                    image: new AssetImage('assets/images/spiderlogo.png'),
                    fit: BoxFit.cover),
                border:
                    Border.all(color: ColorGlobal.colorPrimaryDark, width: 2),
                borderRadius:
                    new BorderRadius.all(const Radius.circular(150.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
