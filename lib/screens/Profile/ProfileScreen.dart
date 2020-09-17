import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iosrecal/models/User.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iosrecal/Constant/Constant.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
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
  String picture;
  int profile_pic_flag = 0;
  User recal_user;
  int getPic = 0;

  Future<dynamic> _fetchPrimaryDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name =
    prefs.getString("name") == null ? "+9,q" : prefs.getString("name");
    String email =
    prefs.getString("email") == null ? "+9,q" : prefs.getString("email");
    String cookie_1 =
    prefs.getString("cookie") == null ? "+9,q" : prefs.getString("cookie");
    String profile_picture =
    prefs.getString("profile_picture") == null ? null : prefs.getString("profile_picture");
    setState(() {
      cookie = cookie_1;
    });
    return {"name": name, "email": email,"profile_picture": profile_picture};
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
  _logoutUser() async {
    var url = "https://delta.nitt.edu/recal-uae/api/auth/logout/";
    await http
        .post(url, headers: {'Cookie': cookie}).then((_response) {
      if (_response.statusCode == 200) {
        ResponseBody responseBody =
        ResponseBody.fromJson(json.decode(_response.body));

        print(json.encode(responseBody.data));
        if (responseBody.status_code == 200) {
          _deleteUserDetails();
          Navigator.pop(context, true);
          Navigator.pushReplacementNamed(context, LOGIN_SCREEN);
        } else {
          _deleteUserDetails();
          print("${responseBody.data}");
          SystemNavigator.pop();
        }
      } else {
        _deleteUserDetails();
        print("Server error");
        SystemNavigator.pop();
      }
    }).catchError((error) {
      _deleteUserDetails();
      print("server error");
      SystemNavigator.pop();
    });
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
                 await _logoutUser();
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

  Future<dynamic> _getUserPicture() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_id =
    prefs.getString("user_id") == null ? -1 : prefs.getString("user_id");
    String cookie =
    prefs.getString("cookie") == null ? "+9,q" : prefs.getString("cookie");

    print("USERID Profile: $user_id");
    print("cookie profile: $cookie");

    var url = "https://delta.nitt.edu/recal-uae/api/users/profile/";
    var uri = Uri.parse(url);
    uri = uri.replace(query: "user_id=$user_id");

    await http.get(uri, headers: {'Cookie': cookie}).then((_response) async {
      print(_response.statusCode);
      print(_response.body);
      if (_response.statusCode == 200) {
        ResponseBody responseBody =
        ResponseBody.fromJson(json.decode(_response.body));
        print(json.encode(responseBody.data));
        if (responseBody.status_code == 200) {
          profile_pic_flag=1;
          recal_user =
              User.fromProfile(json.decode(json.encode(responseBody.data)));
          picture = recal_user.profile_pic;
          if(picture!=null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("profile_picture","https://delta.nitt.edu/recal-uae" + picture);
          }
          print("display picture get: $picture");
          setState(() {
            if (picture != null) {
              setState(() {
                picture =
                    "https://delta.nitt.edu/recal-uae" + picture;
                getPic = 1;
              });
            }
          });
        } else {
          profile_pic_flag=2;
          print("${responseBody.data}");
        }
      } else {
        profile_pic_flag=2;
        print("Server error");
      }
    }).catchError((error) {
      profile_pic_flag=2;
      print(error);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = _fetchPrimaryDetails();
    _getUserPicture();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    final Map<String, Object> getData =
//        ModalRoute.of(context).settings.arguments;
//    if (getData != null) {
//      picture = getData["picture"];
//    }

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
          backgroundColor: ColorGlobal.whiteColor,
          appBar: AppBar(
            backgroundColor: ColorGlobal.whiteColor,
            title: Text(
              'Profile',
              style: TextStyle(color: ColorGlobal.textColor),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 30,
                color: ColorGlobal.textColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
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
                    tag: 'profile_picture',
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, PICTURE_SCREEN,
                            arguments: {"picture": picture, "user": user});
                      },
                      child: profile_pic_flag == 0 ? CircularProgressIndicator() :
                          picture!=null?
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        height: 160,
                        width: 160,
                        decoration: new BoxDecoration(
                          color: ColorGlobal.colorPrimaryDark,
                          image: new DecorationImage(
                            image : NetworkImage(picture),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                              color: ColorGlobal.colorPrimaryDark,
                              width: 2),
                          borderRadius: new BorderRadius.all(
                              const Radius.circular(80.0)),
                        ),
                      ) : CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.orange,
                            child: FutureBuilder<dynamic> (
                              future: user,
                              builder: (context,snapshot) {
                                if(snapshot.hasData) {
                                  return Text("${snapshot.data["name"]}".toUpperCase()[0], style: TextStyle(color: Colors.white, fontSize: 80),);
                                }
                                else if (snapshot.hasError) {
                                  return Text("X", style: TextStyle(color: Colors.white, fontSize: 80),);
                                }
                                return CircularProgressIndicator();
                              },
                            ),
                          ),
                    ),
                  ),
                  ),
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
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pushNamed(
                                  context,EDIT_PROFILE_SCREEN)
                              .then((value) {
                            profile_pic_flag=1;
                            getPic=0;
                            user = _fetchPrimaryDetails();
                            _getUserPicture();
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
                          height: 0.05 * height,
                        ),
                      ),
//                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class PictureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, Object> getData =
        ModalRoute.of(context).settings.arguments;
    String picture=null;
    Future <dynamic> user;
    if (getData != null) {
      picture = getData["picture"];
      user = getData["user"];
    }
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Hero(
              tag: 'profile_picture',
             child: picture!=null?  Container(
               padding: EdgeInsets.symmetric(horizontal: 20),
               height: 300,
               width: 300,
               decoration: new BoxDecoration(
                 color: ColorGlobal.colorPrimaryDark,
                 image: new DecorationImage(
                   image : NetworkImage(picture),
                   fit: BoxFit.cover,
                 ),
                 border: Border.all(
                     color: ColorGlobal.colorPrimaryDark,
                     width: 2),
                 borderRadius: new BorderRadius.all(
                     const Radius.circular(150.0)),
               ),
             ) : CircleAvatar(
               radius: 150,
               backgroundColor: Colors.orange,
               child: FutureBuilder<dynamic> (
                 future: user,
                 builder: (context,snapshot) {
                   if(snapshot.hasData) {
                     return Text("${snapshot.data["name"]}".toUpperCase()[0], style: TextStyle(color: Colors.white, fontSize: 150),);
                   }
                   else if (snapshot.hasError) {
                     return Text("X", style: TextStyle(color: Colors.white, fontSize: 150),);
                   }
                   return CircularProgressIndicator();
                 },
               ),
             ),
            ),
          ),
        ),
      ),
    );
  }
}
