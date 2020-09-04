import 'dart:core';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/Events/EventsScreen.dart';
import 'package:iosrecal/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant/ColorGlobal.dart';
import '../Constant/Constant.dart';
import 'package:badges/badges.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/CoreCommModel.dart';
import 'dart:convert';
import 'package:iosrecal/models/ResponseBody.dart';

class HomeActivity extends StatefulWidget {
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

  Future<CoreCommModel> _corecomm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await http.get(
        "https://delta.nitt.edu/recal-uae/api/chapter/core/",
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


  static List<String> _events = [
    "Social",
    "Events",
    "Mentor Support",
    "Employment",
  ];



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
  void initState()  {
    // TODO: implement initState
    super.initState();
    _getUserPicture();
    user = _fetchPrimaryDetails();
  }
  var dropdownItems=["Volunteer","Write to admin","Write to mentor","Survey"];
  var _currentItemSelected="Volunteer";
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
        appBar:AppBar(
          backgroundColor: ColorGlobal.whiteColor,
          centerTitle: true,
          leading: Card(
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 60,
              child: Image.asset(
                'assets/images/recal_circle.png',
                fit: BoxFit.contain,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius:
                new BorderRadius.circular(60)),
          ),
          title:Text(
            'RECAL UAE CHAPTER',
            style: GoogleFonts.josefinSans(color: ColorGlobal.textColor, fontWeight: FontWeight.bold,fontSize: 20),
          ),
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
        ),
        body: Stack(
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
//                Container(
//                  padding: EdgeInsets.only(top: 10),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      AutoSizeText(
//                        "RECAL UAE CHAPTER",
//                        style: GoogleFonts.lato(
//                            fontSize: 20,
//                            fontWeight: FontWeight.bold,
//                            color: ColorGlobal.whiteColor
//                        ),
//                        maxLines: 1,
//                      ),
//                    ],
//                  ),
//                ),
//                Stack(
//                    fit: StackFit.loose,
//                    children:[
//                      Container(
//                        width: width,
//                        child: Card(
//                          child:Row(
//                            children: <Widget>[
//                              Container(
//                                  padding: EdgeInsets.all(10.0),
//                                  width: width*0.9,
//                                  child: Text("No new messagessfjf adjfjggj jdejf ajdfh ajf dfjfg sdjfdjfhfgjfkgjfgfjgfjieiddkndsnhuaheuajndawuhna;woeiiej!!",overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 15),)),
//                            ],
//                          ),
//                          elevation: 5,
////                     shape: RoundedRectangleBorder(
////                       borderRadius: BorderRadius.circular(15),
////                     ),
//                        ),
//                      ),
//                      Container(
//                        width: width*0.95,
//                        height: height*0.07,
//                        child: Row(
//                          mainAxisAlignment:MainAxisAlignment.end,
//                          children: <Widget>[
//                            Badge(
//                              badgeContent: Text('3',style: TextStyle(color: Colors.white),),
//                              badgeColor: Colors.green,
//                              child: Icon(Icons.notifications,size: 28,color: Colors.grey[700],),
//                            )
//                          ],
//                        ),
//                      ),
//                    ]
//                ),
                Hero(
                  tag: "profile_picture",
                  child: Padding(
                    padding: const EdgeInsets.only(top:15.0,left: 20,right: 20),
                    child: GestureDetector(

                      onTap: (){
                      Navigator.pushNamed(context,PROFILE_SCREEN,arguments: {"picture": picture}).then((value) {
                        profile_pic_flag=0;
                        getPic=0;
                        user = _fetchPrimaryDetails();
                        _getUserPicture();
                      });
                      },
                        child: profile_pic_flag == 0 ?
                        CircularProgressIndicator() :
                        Container(
                          height: width/8,
                          width: width/8,
                          decoration: new BoxDecoration(

                            image: new DecorationImage(
                              image: picture==null ? AssetImage(
                                  'assets/images/nitt_logo.png') : NetworkImage(picture),
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                            new BorderRadius.all(

                                 Radius.circular(
                                    width/8)),
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
                            return Container(
                              width: width*0.8,
                              child: Center(
                                child: Text(
                                  "Welcome "+"${snapshot.data["name"]}",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.josefinSans(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: ColorGlobal.whiteColor
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }
                          // By default, show a loading spinner.
                          return CircularProgressIndicator();
                        },
                      ),
                    ],
                  ),
                ),
//                Container(
//                  margin: EdgeInsets.only(top: 0.1 * height, left: 20),
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        children: <Widget>[
////                          Card(
////                            child: Container(
////                              padding: EdgeInsets.only(top: 10),
////                              height: 0.1 * height,
////                              width: 0.1 * height,
////                              decoration: new BoxDecoration(
////                                color: ColorGlobal.colorPrimaryDark,
////                                image: new DecorationImage(
////                                  image: new AssetImage(
////                                      'assets/images/spiderlogo.png'),
////                                  fit: BoxFit.contain,
////                                ),
////                                border: Border.all(
////                                    color: ColorGlobal.colorPrimaryDark,
////                                    width: 2),
////                                borderRadius: new BorderRadius.all(
////                                    Radius.circular(0.1 * height)),
////                              ),
////                            ),
////                            elevation: 15,
////                            shape: RoundedRectangleBorder(
////                                borderRadius:
////                                    new BorderRadius.circular(width / 6)),
////                          ),
////                          SizedBox(
////                            width: 10,
////                          ),
//                        ],
//                      ),
//                    ],
//                  ),
//                ),
                Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, NOTIFICATION_MENU);
                        },
                        child: Column(
                          children: <Widget>[
                            Card(
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: width / 10,
                                child: Badge(
                                  badgeContent: Text('5',style: TextStyle(color: Colors.white),),
                                  badgeColor: Colors.green,
                                  position: BadgePosition.topRight(top: -8, right: -8),
                                  child: Image.asset(
                                    'assets/images/chat.png',
                                    color: Colors.blue[800],
                                    height: width / 8,
                                    width: width / 8,
                                  ),
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
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: ColorGlobal.whiteColor),
                            ),
                            Text(
                              "View Messages",
                              style: TextStyle(
                                  fontFamily: 'Pacifico',
                                  fontSize: 13,
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
                                  color: Colors.blue[700],
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
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: ColorGlobal.whiteColor),
                            ),
                            Text(
                              "Checkout Events",
                              style: TextStyle(
                                  fontFamily: 'Pacifico',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: ColorGlobal.whiteColor.withOpacity(0.7)),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) =>
                              EventsScreen(1)));
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
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: ColorGlobal.textColor),
                              ),
                              Text(
                                "Social Network",
                                style: TextStyle(
                                    fontFamily: 'Pacifico',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: ColorGlobal.textColor.withOpacity(0.7)),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, SOCIAL_MEDIA);
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
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: ColorGlobal.textColor),
                              ),
                              Text(
                                "Job Positions",
                                style: TextStyle(
                                    fontFamily: 'Pacifico',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: ColorGlobal.textColor.withOpacity(0.7)),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context,EMPLOYMENT_SUPPORT);
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
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: ColorGlobal.textColor),
                              ),
                              Text(
                                "Mentor Groups",
                                style: TextStyle(
                                    fontFamily: 'Pacifico',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: ColorGlobal.textColor.withOpacity(0.7)),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context,MENTOR_GROUPS);
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
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: ColorGlobal.textColor),
                                  ),
                                  Text(
                                    "Go Social",
                                    style: TextStyle(
                                        fontFamily: 'Pacifico',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: ColorGlobal.textColor.withOpacity(0.7)),
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                              onTap: () {
                                Navigator.pushNamed(context,SOCIAL);
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
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: ColorGlobal.textColor),
                                  ),
                                  Text(
                                    "Business Group",
                                    style: TextStyle(
                                        fontFamily: 'Pacifico',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: ColorGlobal.textColor.withOpacity(0.7)),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.pushNamed(context,BUSINESS);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
//                FlatButton(
//                  onPressed: () async {
//                    List<String> branch = [
//                      "ECE",
//                      "EEE",
//                      "MECH",
//                      "PROD",
//                      "CHEM",
//                      "META",
//                      "ARCHI",
//                      "PhD/MSc/MS",
//                      "M.DOMS",
//                      "MCA",
//                      "MTECH"
//                    ];
//                    int i=0;
//                    for(i=0;i<branch.length;i++) {
//
//                      SharedPreferences prefs = await SharedPreferences.getInstance();
//                      var url = "https://delta.nitt.edu/recal-uae/api/branch/add/";
//                      var body = {'branch_name': branch[i]};
//                      await http
//                          .post(
//                        url,
//                        body: body,
//                          headers: {
//                            "Accept": "application/json",
//                            "Cookie": "${prefs.getString("cookie")}",
//                          }
//                      )
//                          .then((_response) {
//                        ResponseBody responseBody = new ResponseBody();
//                        print('Response body: ${_response.body}');
//                        if (_response.statusCode == 200) {
////        updateCookie(_response);
//                          responseBody = ResponseBody.fromJson(
//                              json.decode(_response.body));
//                          if (responseBody.status_code == 200) {
//                            print("success ${branch[i]}");
//                          } else {
//                            print("fail ${branch[i]}");
//                            print(responseBody.data);
//                          }
//                        } else {
//                          print("fail ${branch[i]}");
//                          print('Server error');
//                        }
//                      });
//                    }
//                  },
//                  child: Text("Update branch"),
//                ),
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