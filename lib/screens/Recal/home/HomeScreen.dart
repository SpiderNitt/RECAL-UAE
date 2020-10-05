import 'dart:core';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/constants/UIUtility.dart';
import 'package:iosrecal/constants/Api.dart';
import 'package:iosrecal/screens/Events/EventsScreen.dart';
import 'package:iosrecal/models/User.dart';
import 'package:iosrecal/widgets/NoInternet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:iosrecal/routes.dart';
import 'package:badges/badges.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/CoreCommModel.dart';
import 'dart:convert';
import 'package:iosrecal/models/ResponseBody.dart';

class HomeActivity extends StatefulWidget {
  const HomeActivity({Key key}) : super(key: key);
  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> {

  Future<String> name;
  static List<String> _members = [];
  int flag=0;
  int profile_pic_flag=0;
  Future<dynamic> user;
  User recal_user;
  String picture;
  int getPic = 0;
  String cookie = "";
  int unreadMessages=0;
  bool internetConnection=true;
  UIUtility uiUtills = new UIUtility();


  refreshFull() {
    setState(() {
      profile_pic_flag=0;
      getPic=0;
      internetConnection=true;
      _getUserPicture();
      _fetchUnreadMessages();
      _fetchPrimaryDetails();
      user = _fetchPrimaryDetails();
    });
  }
  refreshInternet() async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          internetConnection = true;
        });
      }
      else {
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
  }
  refreshMessages () async {
    await _fetchUnreadMessages();
  }


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
  Future<dynamic> _getUserPicture() async {

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          internetConnection = true;
        });
      }
      else {
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
          profile_pic_flag=1;
          recal_user =
              User.fromProfile(json.decode(json.encode(responseBody.data)));
          picture = recal_user.profile_pic;
          print("picture : " + picture.toString());
          if(picture!=null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("profile_picture",Api.imageUrl + picture);
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
        }
        else if(responseBody.status_code==401){
          onTimeOut();
        }
        else {
          profile_pic_flag=2;
          print("${responseBody.data}");
        }
      }
      else {
        profile_pic_flag=2;
        print("Server error");
      }
    }).catchError((error) {
      profile_pic_flag=2;
      print(error);
    });
  }

  Future<CoreCommModel> _corecomm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await http.get(
        Api.chapterCore,
        headers: {
          "Accept": "application/json",
          "Cookie": "${prefs.getString("cookie")}",
        }
    ).then((_response) {
      ResponseBody responseBody = new ResponseBody();
      print('Response body: ${_response.body}');
      if (_response.statusCode == 200) {
        responseBody = ResponseBody.fromJson(json.decode(_response.body));
        if (responseBody.status_code == 200) {
          if(responseBody.data!=null) {
            responseBody.data['president']!=null ? _members.add(responseBody.data['president']) : print("empty");
            responseBody.data['vice_president']!=null ?    _members.add(responseBody.data['vice_president']): print("empty");
            responseBody.data['secretary']!=null  ? _members.add(responseBody.data['secretary']): print("empty");
            responseBody.data['joint_secretary']!=null   ?_members.add(responseBody.data['joint_secretary']): print("empty");
            responseBody.data['treasurer']!=null  ? _members.add(responseBody.data['treasurer']): print("empty");
            responseBody.data['mentor1']!=null  ? _members.add(responseBody.data['mentor1']): print("empty");
            responseBody.data['mentor2']!=null  ? _members.add(responseBody.data['mentor2']): print("empty");
            if(_members.length>0)
              setState(() {
                flag=1;
              });
            else
              setState(() {
                flag=2;
              });

            print("members: ");
            print(_members);
          }
        } else {
          setState(() {
            flag=2;
          });
          print(responseBody.data);
        }
      } else {
        setState(() {
          flag=2;
        });
        print('Server error');
      }
    });
  }




  String _getLongestString() {
    if(flag==1) {
      var s = _members[0];
      for (int i = 1; i < 7; i++) {
        if (_members[i].length > s.length) s = _members[i];
      }
      return s;
    }
    else
      return "Abcdef Ghijk";
  }

  static List<String> _roles = [
    "President",
    "Vice President",
    "Secretary",
    "Joint Secretary",
    "Treasurer",
    "Mentor 1",
    "Mentor 2",
  ];
  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
//  Future<String> _fetchUserName() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String name = prefs.getString("name")==null ? "+9,q": prefs.getString("name");
//    return name;
//  }
  _deleteUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", null);
    prefs.setString("name", null);
    prefs.setInt("user_id", null);
    prefs.setString("cookie", null);
    prefs.setString("profile_picture", null);

  }
  _logoutUser() async {
    var url = Api.logout;
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
          Navigator.pop(context,true);
          Navigator.pushReplacementNamed(context, LOGIN_SCREEN);
        }
      }
      else {
        _deleteUserDetails();
        print("Server error");
        Navigator.pop(context,true);
        Navigator.pushReplacementNamed(context, LOGIN_SCREEN);
      }
    }).catchError((error) {
      _deleteUserDetails();
      print("server error");
      Navigator.pop(context,true);
      Navigator.pushReplacementNamed(context, LOGIN_SCREEN);
    });
  }

  _fetchUnreadMessages() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          internetConnection = true;
        });
      }
      else {
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Api.getAllNotifications + "${prefs.getString("user_id")}" + '&page=1';
    print(url);
    var response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Cookie": "${prefs.getString("cookie")}",
        }
    );
    ResponseBody responseBody = new ResponseBody();

    if (response.statusCode == 200) {
      print("got response");
//        updateCookie(_response);
      responseBody = ResponseBody.fromJson(json.decode(response.body));
      print(responseBody.data);
      if (responseBody.status_code == 200) {
        setState(() {
          unreadMessages = responseBody.data["unread"];
        });
      }
      else {
        print(responseBody.data);
      }
    } else {
      print('Server error');
    }
  }

  Future<bool> _onLogoutPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('Logout?'),
        content : Text('You will return to the login screen.'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          FlatButton(
            onPressed: () async => await _logoutUser(),
            child: Text("YES"),
          )
        ],
      ),
    ) ??
        false;
  }
  navigateAndReload(){
    Navigator.pushNamed(context, LOGIN_SCREEN, arguments: true)
        .then((value) {
      Navigator.pop(context);
      setState(() {
        _getUserPicture();
        user = _fetchPrimaryDetails();
        _fetchUnreadMessages();
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


  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    uiUtills = new UIUtility();
    internetConnection=true;
    _getUserPicture();
    user = _fetchPrimaryDetails();
    _fetchUnreadMessages();

  }
  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    uiUtills.updateScreenDimesion(width: width, height: height);

    final Size coreSize = _textSize(
        "Core Committee",
        TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ColorGlobal.textColor));

    final socialSize = _textSize(
      "Social",
      TextStyle(
          fontFamily: 'Pacifico',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: ColorGlobal.textColor),
    );
    final goSocialSize = _textSize(
      _members.length>0 ? _getLongestString() : "Abcdef Ghijk",
      TextStyle(
        fontSize: 11,
        letterSpacing: 1,
        color: ColorGlobal.textColor,
        fontWeight: FontWeight.w700,
      ),
    );

    final alumniName = _textSize(
      "Go Social",
      TextStyle(
          fontFamily: 'Pacifico',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: ColorGlobal.textColor.withOpacity(0.7)),
    );

    print(height -
        (0.325 * height +
            width / 5 +
            goSocialSize.height +
            socialSize.height +
            coreSize.height +
            10));
    print(0.4 * height);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar:PreferredSize(
          preferredSize: Size.fromHeight(getHeight(60, 1)),
          child: AppBar(
            backgroundColor: ColorGlobal.whiteColor,
            centerTitle: true,
            leading: Card(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: getWidth(60, 1),
                child: Image.asset(
                  'assets/images/recal_circle.png',
                  fit: BoxFit.contain,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius:
                  new BorderRadius.circular(getHeight(60, 1))),
            ),
            title:Text(
              'RECAL UAE CHAPTER',
              style: GoogleFonts.josefinSans(color: ColorGlobal.textColor, fontWeight: FontWeight.bold,fontSize: getWidth(20, 1)),
            ),
            actions: <Widget>[
              IconButton(
                padding: EdgeInsets.only(right: getWidth(20, 1)),
                icon: Icon(
                  Icons.exit_to_app,
                  size: getWidth(35, 1),
                  color: ColorGlobal.textColor,
                ),
                onPressed: () {
                  _onLogoutPressed();
                },
              )
            ],
          ),
        ),
        body: internetConnection==false ? NoInternetScreen(notifyParent: refreshFull) :
            profile_pic_flag==0 ? Center(child: SpinKitSquareCircle(
              color:ColorGlobal.blueColor,
            ),
            ) :
        SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              ClipRRect(
                child: Container(
                  height: height * 0.05,
                  color: ColorGlobal.blueColor,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(height * 0.05),
                child: Container(
                  height: height * 0.460,
                  color: ColorGlobal.blueColor,
                ),
              ),
              Column(
                children: <Widget>[
                  Hero(
                    tag: "profile_picture",
                    child: Padding(
                      padding: const EdgeInsets.only(top:15.0,left: 20,right: 20),
                      child: GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context,PROFILE_SCREEN,arguments: {"picture": picture}).then((value) {
                              refreshFull();
                            });
                          },
                          child: profile_pic_flag == 0 ?
                          CircularProgressIndicator(backgroundColor: Colors.orange) :
                              picture != null ?
                          Container(
                            height: width/7,
                            width: width/7,
                            decoration: new BoxDecoration(
                              image: new DecorationImage(
                                image: NetworkImage(picture),
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                              new BorderRadius.all(
                                  Radius.circular(
                                      width/7)),
                            ),
                          ) : CircleAvatar(
                                radius: width/14,
                                backgroundColor: Colors.orange,
                                child: FutureBuilder<dynamic> (
                                  future: user,
                                  builder: (context,snapshot) {
                                    if(snapshot.hasData) {
                                      return Text("${snapshot.data["name"]}".toUpperCase()[0], style: TextStyle(color: Colors.white, fontSize: width/14),);
                                    }
                                    else if (snapshot.hasError) {
                                      onTimeOut();
                                    }
                                    return CircularProgressIndicator();
                                  },
                                ),
                              )
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:10.0,left: 20,right: 20, bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FutureBuilder<dynamic>(
                          future: user,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Expanded(
                                child: Container(
                                  width: width*0.99,
                                  child: Center(
                                    child: AutoSizeText(
                                      "Welcome "+"${snapshot.data["name"]}",
                                      style: GoogleFonts.josefinSans(
                                          fontSize: getWidth(25, 1),
                                          fontWeight: FontWeight.bold,
                                          color: ColorGlobal.whiteColor
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              onTimeOut();
                            }
                            // By default, show a loading spinner.
                            return CircularProgressIndicator();
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, NOTIFICATION_MENU).then((value) async {
                              await refreshMessages();
                            });
                          },
                          child: Column(
                            children: <Widget>[
                              Card(
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: width / 10,
                                  child: unreadMessages !=0 ? Badge(
                                    badgeContent: Text(unreadMessages>9 ? "9+" : unreadMessages.toString(),style: TextStyle(color: Colors.white),),
                                    badgeColor: Colors.green,
                                    position: BadgePosition(top:0, right: 0),
                                    child: Image.asset(
                                      'assets/images/chat.png',
                                      color: Colors.blue[800],
                                      height: width / 8,
                                      width: width / 8,
                                    ),
                                  ) : Image.asset(
                                    'assets/images/chat.png',
                                    color: Colors.blue[800],
                                    height: width / 8,
                                    width: width / 8,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(width / 10)),
                              ),
                              Text(
                                "Message",
                                style: TextStyle(
                                    fontFamily: 'Pacifico',
                                    fontSize: getWidth(15, 1),
                                    fontWeight: FontWeight.bold,
                                    color: ColorGlobal.whiteColor),
                              ),
                              Text(
                                "View Messages",
                                style: TextStyle(
                                    fontFamily: 'Pacifico',
                                    fontSize: getWidth(13, 1),
                                    fontWeight: FontWeight.w600,
                                    color: ColorGlobal.whiteColor.withOpacity(0.7)),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),

                        ),
                        SizedBox(
                          width: width/5,
                        ),
                        GestureDetector(
                          child: Column(
                            children: <Widget>[
                              Card(
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: width / 10,
                                  child: Image.asset(
                                    'assets/images/calendar.png',
                                    height: width / 8,
                                    width: width / 8,
                                    color: Colors.blue[600],
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(width / 10)),
                              ),
                              Text(
                                "Events",
                                style: TextStyle(
                                    fontFamily: 'Pacifico',
                                    fontSize: getWidth(15, 1),
                                    fontWeight: FontWeight.bold,
                                    color: ColorGlobal.whiteColor),
                              ),
                              Text(
                                "Checkout Events",
                                style: TextStyle(
                                    fontFamily: 'Pacifico',
                                    fontSize: getWidth(13, 1),
                                    fontWeight: FontWeight.w600,
                                    color: ColorGlobal.whiteColor.withOpacity(0.7)),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context) =>
                                EventsScreen(1))).then((value) {
                              refreshInternet();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: height * 0.40),
                    child: Column(
                      children: [Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                            child: Column(
                              children: <Widget>[
                                Card(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: width / 10,
                                    child: Image.asset(
                                      'assets/images/social_media.png',
                                      height: width / 9,
                                      width: width / 9,
                                      color: Colors.blue[800],
                                    ),
                                  ),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      new BorderRadius.circular(width / 10)),
                                ),
                                Text(
                                  "Social Media",
                                  style: TextStyle(
                                      fontFamily: 'Pacifico',
                                      fontSize: getWidth(15, 1),
                                      fontWeight: FontWeight.bold,
                                      color: ColorGlobal.textColor),
                                ),
                                Text(
                                  "Social Network",
                                  style: TextStyle(
                                      fontFamily: 'Pacifico',
                                      fontSize: getWidth(13, 1),
                                      fontWeight: FontWeight.w600,
                                      color: ColorGlobal.textColor.withOpacity(0.7)),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, SOCIAL_MEDIA).then((value) {
                                refreshInternet();
                              });
                            },
                          ),
                          GestureDetector(
                            child: Column(
                              children: <Widget>[
                                Card(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: width / 10,
                                    child: Image.asset(
                                      'assets/images/application.png',
                                      color: Colors.blue[800],
                                      height: width / 10,
                                      width: width / 10,
                                    ),

                                  ),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      new BorderRadius.circular(width / 10)),
                                ),
                                Text(
                                  "Employment",
                                  style: TextStyle(
                                      fontFamily: 'Pacifico',
                                      fontSize: getWidth(15, 1),
                                      fontWeight: FontWeight.bold,
                                      color: ColorGlobal.textColor),
                                ),
                                Text(
                                  "Job Positions",
                                  style: TextStyle(
                                      fontFamily: 'Pacifico',
                                      fontSize: getWidth(13, 1),
                                      fontWeight: FontWeight.w600,
                                      color: ColorGlobal.textColor.withOpacity(0.7)),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.pushNamed(context,EMPLOYMENT_SUPPORT).then((value) {
                                refreshInternet();
                              });
                            },
                          ),
                          GestureDetector(
                            child: Column(
                              children: <Widget>[
                                Card(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: width / 10,
                                    child: Image.asset(
                                      'assets/images/scholarship.png',
                                      color: Colors.blue[800],
                                      height: width / 10,
                                      width: width / 10,
                                    ),

                                  ),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      new BorderRadius.circular(width / 10)),
                                ),
                                Text(
                                  "Mentorship",
                                  style: TextStyle(
                                      fontFamily: 'Pacifico',
                                      fontSize: getWidth(15, 1),
                                      fontWeight: FontWeight.bold,
                                      color: ColorGlobal.textColor),
                                ),
                                Text(
                                  "Mentor Groups",
                                  style: TextStyle(
                                      fontFamily: 'Pacifico',
                                      fontSize: getWidth(13, 1),
                                      fontWeight: FontWeight.w600,
                                      color: ColorGlobal.textColor.withOpacity(0.7)),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.pushNamed(context,MENTOR_GROUPS).then((value) {
                                refreshInternet();
                              });
                            },
                          ),
                        ],
                      ),
                        Padding(
                          padding: const EdgeInsets.only(top:10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                child: Column(
                                  children: <Widget>[
                                    Card(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: width / 10,
                                        child: Image.asset(
                                          'assets/images/network.png',
                                          color: Colors.blue[800],
                                          height: width / 10,
                                          width: width / 10,
                                        ),
                                      ),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          new BorderRadius.circular(width / 10)),
                                    ),
                                    Text(
                                      "Social",
                                      style: TextStyle(
                                          fontFamily: 'Pacifico',
                                          fontSize: getWidth(15, 1),
                                          fontWeight: FontWeight.bold,
                                          color: ColorGlobal.textColor),
                                    ),
                                    Text(
                                      "Go Social",
                                      style: TextStyle(
                                          fontFamily: 'Pacifico',
                                          fontSize: getWidth(13, 1),
                                          fontWeight: FontWeight.w600,
                                          color: ColorGlobal.textColor.withOpacity(0.7)),
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context,SOCIAL).then((value) {
                                    refreshInternet();
                                  });
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                child: Column(
                                  children: <Widget>[
                                    Card(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: width / 10,
                                        child: Image.asset(
                                          'assets/images/busi_group.png',
                                          height: width / 9,
                                          width: width / 9,
                                          color: Colors.blue[800],
                                        ),
                                      ),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        new BorderRadius.circular(width / 10),
                                      ),
                                    ),
                                    Text(
                                      "Business",
                                      style: TextStyle(
                                          fontFamily: 'Pacifico',
                                          fontSize: getWidth(15, 1),
                                          fontWeight: FontWeight.bold,
                                          color: ColorGlobal.textColor),
                                    ),
                                    Text(
                                      "Business Group",
                                      style: TextStyle(
                                          fontFamily: 'Pacifico',
                                          fontSize: getWidth(13, 1),
                                          fontWeight: FontWeight.w600,
                                          color: ColorGlobal.textColor.withOpacity(0.7)),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context,BUSINESS).then((value) {
                                    refreshInternet();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              (height -
                  (0.325 * height +
                      width / 5 +
                      goSocialSize.height +
                      socialSize.height +
                      coreSize.height +
                      40)) >=
                  0.4 * height
                  ?  (flag==1 ? Positioned(
                top: 0.325 * height +
                    width / 5 +
                    goSocialSize.height +
                    socialSize.height +
                    40,
                left: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Core Committee: ",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: ColorGlobal.textColor),
                  ),
                ),
              ) :  SizedBox())
                  : SizedBox(),
              (height -
                  (0.325 * height +
                      width / 5 +
                      goSocialSize.height +
                      socialSize.height +
                      coreSize.height +
                      40)) >=
                  0.4 * height

                  ? (flag ==1 ?  Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  height: 0.2 * height,
                  width: width,
                  child: new ListView.builder(
                    itemCount: 7,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, i) {
                      return Container(
                        width: width * 0.4,
                        height: 0.2 * height,
                        margin: EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: <Widget>[
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        height * 0.10)),
                                child: Container(
                                  height: height * 0.10,
                                  width: height * 0.10,
                                  decoration: new BoxDecoration(
                                    color: ColorGlobal.colorPrimaryDark,
                                    image: new DecorationImage(
                                      image: new AssetImage(
                                          'assets/images/mentor.png'),
                                      fit: BoxFit.contain,
                                    ),
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(height * 0.10)),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: AutoSizeText(
                                      "${_members[i]}",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: ColorGlobal.textColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "${_roles[i]}",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 9,
                                        letterSpacing: 1,
                                        color: ColorGlobal.textColor
                                            .withOpacity(0.6),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ) : flag==2 ? SizedBox() : Positioned(
                  top: 0.325 * height +
                      width / 5 +
                      goSocialSize.height +
                      socialSize.height +
                      40,
                  left: width/2 - 20,
                  child: SizedBox()))
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class Header extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}