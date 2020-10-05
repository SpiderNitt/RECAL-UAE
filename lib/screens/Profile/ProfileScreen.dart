import 'dart:io';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iosrecal/constants/UIUtility.dart';
import 'package:iosrecal/constants/Api.dart';
import 'package:iosrecal/models/User.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/widgets/NoInternet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iosrecal/routes.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:badges/badges.dart';
import 'pages/EditProfile.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<dynamic> user;
  String cookie = "";
  String picture;
  int profile_pic_flag = 0;
  User recal_user;
  int getPic = 0;
  bool internetConnection = false;
  UIUtility uiUtills = new UIUtility();


  Future<dynamic> _fetchPrimaryDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name =
    prefs.getString("name") == null ? "+9,q" : prefs.getString("name");
    String email =
    prefs.getString("email") == null ? "+9,q" : prefs.getString("email");
    String cookie_1 =
    prefs.getString("cookie") == null ? "+9,q" : prefs.getString("cookie");
    String profile_picture =
    prefs.getString("profile_picture") == null ? null : prefs.getString(
        "profile_picture");
    setState(() {
      cookie = cookie_1;
    });
    return {"name": name, "email": email, "profile_picture": profile_picture};
  }

  _logoutDialog(String show, String again, int flag) {
    return showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
        title: Text('Logout Check'),
        content: new Text(show),
        actions: <Widget>[
          new GestureDetector(
            onTap: () {
              flag != 1
                  ? Navigator.of(context).pop(false)
                  : Navigator.pushReplacementNamed(context, HOME_SCREEN);
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


  navigateAndReload() {
    Navigator.pushNamed(context, LOGIN_SCREEN, arguments: true)
        .then((value) {
      Navigator.pop(context);
      setState(() {
        user = _fetchPrimaryDetails();
        _getUserPicture();
      });
    });
  }
  Future<bool> onTimeOut() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: new Text('Session Timeout'),
        content: new Text('Login to continue'),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              navigateAndReload();
            },
            child: Text("OK"),
          ),
        ],
      ),
    ) ??
        false;
  }


  Future<dynamic> _getUserPicture() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          internetConnection = true;
        });
      }
      else {
        setState(() {
          internetConnection = false;
        });
        Fluttertoast.showToast(
          msg: "Please connect to internet",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16,
        );
      }
    } on SocketException catch (_) {
      print('not connected');
      Fluttertoast.showToast(
        msg: "Please connect to internet",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16,
      );
      setState(() {
        internetConnection = false;
      });
    }
    if (internetConnection == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user_id =
      prefs.getString("user_id") == null ? -1 : prefs.getString("user_id");
      String cookie =
      prefs.getString("cookie") == null ? "+9,q" : prefs.getString("cookie");

      print("USERID Profile: $user_id");
      print("cookie profile: $cookie");

      var url = Api.getUser;
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
            profile_pic_flag = 1;
            recal_user =
                User.fromProfile(json.decode(json.encode(responseBody.data)));
            picture = recal_user.profile_pic;
            if (picture != null) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("profile_picture",
                  Api.imageUrl + picture);
            }
            print("display picture get: $picture");
            setState(() {
              if (picture != null) {
                setState(() {
                  picture =
                      Api.imageUrl + picture;
                  getPic = 1;
                });
              }
            });
          } else if (responseBody.status_code == 401) {
            onTimeOut();
          }
          else {
            profile_pic_flag = 2;
            print("${responseBody.data}");
          }
        } else {
          profile_pic_flag = 2;
          print("Server error");
        }
      }).catchError((error) {
        profile_pic_flag = 2;
        print(error);
      });
    }
}
refresh () {
    setState(() {
      internetConnection=false;
      profile_pic_flag=0;
      getPic=0;
      _getUserPicture();
      user = _fetchPrimaryDetails();
    });
}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uiUtills = new UIUtility();
    user = _fetchPrimaryDetails();
    _getUserPicture();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }


  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    uiUtills.updateScreenDimesion(width: width,height: height);

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
                Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                size: 30,
                color: ColorGlobal.textColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: internetConnection==false? NoInternetScreen(notifyParent: refresh,) : SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: getHeight(30, 1),
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
                        padding: EdgeInsets.symmetric(horizontal: getWidth(20, 1)),
                        height: getWidth(160, 1),
                        width: getWidth(160, 1),
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
                               Radius.circular(getWidth(80, 1))),
                        ),
                      ) : CircleAvatar(
                            radius: getWidth(80, 1),
                            backgroundColor: Colors.orange,
                            child: FutureBuilder<dynamic> (
                              future: user,
                              builder: (context,snapshot) {
                                if(snapshot.hasData) {
                                  return Text("${snapshot.data["name"]}".toUpperCase()[0], style: TextStyle(color: Colors.white, fontSize: getWidth(80, 1)),);
                                }
                                else if (snapshot.hasError) {
                                  onTimeOut();
                                }
                                return CircularProgressIndicator();
                              },
                            ),
                          ),
                    ),
                  ),
                  ),
                  SizedBox(
                    height: getHeight(10, 1),
                  ),
                  Center(
                    child: Container(
                      child: FutureBuilder<dynamic>(
                        future: user,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: AutoSizeText(
                                    "${snapshot.data["name"]}",
                                    wrapWords: true,
                                    style: TextStyle(
                                      fontSize: getWidth(18, 1),
                                      color: ColorGlobal.textColor
                                          .withOpacity(0.9),
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(height: getHeight(5, 1)),
                                AutoSizeText(
                                  "${snapshot.data["email"]}",
                                  wrapWords: true,
                                  style: TextStyle(
                                    fontSize: getWidth(16, 1),
                                    color: ColorGlobal.textColor
                                        .withOpacity(0.6),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            onTimeOut();
                          }
                          // By default, show a loading spinner.
                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: getWidth(20, 1), vertical: getHeight(10, 1)),
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
                              fontSize: getWidth(15, 1),
                                color: ColorGlobal.textColor,
                                fontWeight: FontWeight.bold),
                          ),
                          height: getWidth(30,1),
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
  UIUtility uiUtills = new UIUtility();
  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }


  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    uiUtills.updateScreenDimesion(width: width,height: height);

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
               padding: EdgeInsets.symmetric(horizontal: getWidth(20, 1)),
               height: getWidth(300, 1),
               width: getWidth(300, 1),
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
                     Radius.circular(getWidth(150, 1))),
               ),
             ) : CircleAvatar(
               radius: getWidth(150, 1),
               backgroundColor: Colors.orange,
               child: FutureBuilder<dynamic> (
                 future: user,
                 builder: (context,snapshot) {
                   if(snapshot.hasData) {
                     return Text("${snapshot.data["name"]}".toUpperCase()[0], style: TextStyle(color: Colors.white, fontSize: getWidth(150, 1)),);
                   }
                   else if (snapshot.hasError) {
                     return Text("X", style: TextStyle(color: Colors.white, fontSize: getWidth(150, 1)),);
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
