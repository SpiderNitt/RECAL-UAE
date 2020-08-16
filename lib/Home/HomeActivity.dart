import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/Events/EventsScreen.dart';
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
  Future<String> _fetchUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString("name")==null ? "+9,q": prefs.getString("name");
    return name;
  }

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    _corecomm();
    setState(() {
      name = _fetchUserName();
    });
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
          leading: Image(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/recal_logo.jpg'),
          ), // you can put Icon as well, it accepts any widget.
          title:Text(
            'RECAL UAE CHAPTER',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context,PROFILE_SCREEN);
                },
                child: CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/images/spiderlogo.png'),
                ),
              ),
            ),
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
                height: height * 0.420,
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
                Stack(
                    fit: StackFit.loose,
                    children:[
                      Container(
                        width: width,
                        child: Card(
                          child:Row(
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.all(10.0),
                                  width: width*0.9,
                                  child: Text("No new messagessfjf adjfjggj jdejf ajdfh ajf dfjfg sdjfdjfhfgjfkgjfgfjgfjieiddkndsnhuaheuajndawuhna;woeiiej!!",overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 15),)),
                            ],
                          ),
                          elevation: 5,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
                        ),
                      ),
                      Container(
                        width: width*0.95,
                        height: height*0.07,
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.end,
                          children: <Widget>[
                            Badge(
                              badgeContent: Text('3',style: TextStyle(color: Colors.white),),
                              badgeColor: Colors.green,
                              child: Icon(Icons.notifications,size: 28,color: Colors.grey[700],),
                            )
                          ],
                        ),
                      ),
                    ]
                ),
                Padding(
                  padding: const EdgeInsets.only(top:30.0,left: 20,right: 20,bottom: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FutureBuilder<String>(
                        future: name,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              width: width*0.8,
                              child: Center(
                                child: Text(
                           "Welcome "+"${snapshot.data}",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(
                                      fontSize: 24,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    Container(
                      width: width*0.5,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0,right: 8,),
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            underline: SizedBox(),
                            items: dropdownItems.map((String dropdownmenuitem){
                              return DropdownMenuItem<String>(
                                  value:dropdownmenuitem,
                                  child: Container(child: Text(dropdownmenuitem,overflow:TextOverflow.ellipsis,maxLines: 1,style:TextStyle(color: Colors.black),))
                              );
                            }).toList(),
                            hint: Text(
                                "Options",
                                style:TextStyle(fontSize: 18)
                            ),
                            onChanged: (String newvalue){
                              setState(() {
                                this._currentItemSelected=newvalue;
                                switch(this._currentItemSelected){
                                  case "Volunteer":{Navigator.pushNamed(context,EMPLOYMENT_SUPPORT);break;}
                                  case "Write to admin":{Navigator.pushNamed(context,WRITE_TO_ADMIN);break;}
                                case "Write to mentor":{Navigator.pushNamed(context,WRITE_MENTOR);break;}
                                default:{Navigator.pushNamed(context,MARKET_SURVEY);break;}
                                }

                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: height * 0.36),
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
                                      'assets/images/calendar.png',
                                      height: width / 9,
                                      width: width / 9,
                                    ),
                                  ),
                                  elevation: 20,
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
                                      color: ColorGlobal.textColor),
                                ),
                                Text(
                                  "Checkout events",
                                  style: TextStyle(
                                      fontFamily: 'Pacifico',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: ColorGlobal.textColor.withOpacity(0.7)),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(context,MaterialPageRoute(builder: (context) =>
                                  EventsScreen()));
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
                                      color: ColorGlobal.blueColor,
                                      height: width / 10,
                                      width: width / 10,
                                    ),
                                  ),
                                  elevation: 20,
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
                                      color: ColorGlobal.blueColor,
                                      height: width / 10,
                                      width: width / 10,
                                    ),
                                  ),
                                  elevation: 20,
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
                                          color: ColorGlobal.blueColor,
                                          height: width / 10,
                                          width: width / 10,
                                        ),
                                      ),
                                      elevation: 20,
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
                                  Navigator.pushNamed(context,SOCIAL_BUSINESS);
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
                                          'assets/images/business.png',
                                          height: width / 9,
                                          width: width / 9,
                                        ),
                                      ),
                                      elevation: 20,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          new BorderRadius.circular(width / 10)),
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
                                  Navigator.pushNamed(context,SOCIAL_BUSINESS);
                                },
                              ),
                            ],
                          ),
                        ),
                      ]),
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
                        elevation: 10,
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