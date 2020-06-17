
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constant/Constant.dart';
import '../Constant/ColorGlobal.dart';
import 'package:badges/badges.dart';
import 'EditProfile.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _unfinished=2;

  _deleteUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userID", null);
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
            onTap: () {
              Navigator.pop(context,true);
              Navigator.of(context).pushReplacementNamed(LOGIN_SCREEN);
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: ColorGlobal.whiteColor,
          appBar: AppBar(
            backgroundColor: ColorGlobal.whiteColor,
            actions: <Widget>[
            IconButton(
              icon: Container(
                child: SvgPicture.asset(
                  "assets/icons/Logout.svg",
                  color: ColorGlobal.textColor,
                ),
                height: 20,
              ),
              onPressed: () {
                _deleteUserDetails();
                _onLogoutPressed();
              },
            )
          ],
            title: Text('Profile',style: TextStyle(color: ColorGlobal.textColor),),
          ),
          body: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 30,),
                    Center(
                      child: Hero(
                        tag: 'profile_pic',
                        child: GestureDetector(
                          onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=> PictureScreen()));},
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 160,
                            width: 160,
                            decoration: new BoxDecoration(
                              color: ColorGlobal.colorPrimaryDark,
                              image: new DecorationImage(
                                image: new AssetImage('assets/images/spiderlogo.png'),
                                fit: BoxFit.contain,
                              ),
                              border: Border.all(color: ColorGlobal.colorPrimaryDark, width: 2),
                              borderRadius:
                              new BorderRadius.all(const Radius.circular(80.0)),
                            ),
                          ),
                        ),
                      )
                    ),
                    SizedBox(height: 10,),
                    Center(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "Madhav Aggarwal",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 18,
                                  letterSpacing: 1,
                                  color: ColorGlobal.textColor.withOpacity(0.9),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              child: Text(
                                "BTech CSE, 2022",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 1,
                                  color:
                                  ColorGlobal.textColor.withOpacity(0.6),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
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
                                    child: EditProfileScreen()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: ColorGlobal.whiteColor,
                                border: Border.all(color: ColorGlobal.textColor),
                                borderRadius: BorderRadius.circular(5.0),
                            ),
                            alignment: Alignment.center,
                            child: Text("Edit Profile",
                                style: TextStyle(
                                    color: ColorGlobal.textColor, fontWeight: FontWeight.bold),
                            ),
                            height: 27.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),


          ),
      )
      ),
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
                  fit: BoxFit.cover
                ),
                border: Border.all(color: ColorGlobal.colorPrimaryDark, width: 2),
                borderRadius:  new BorderRadius.all(const Radius.circular(150.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
