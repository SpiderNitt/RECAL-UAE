import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constant/Constant.dart';
import 'SocialBusinessScreen.dart';
import '../Constant/HomeCards.dart';
import '../Constant/ColorGlobal.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static List<String> _events = [
    "Social",
    "Events",
    "Mentor Support",
    "Employment",
  ];

  @override
  Widget build(BuildContext context) {
    final screeSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorGlobal.whiteColor,
          title: Text(
            'Home',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: Stack(
          children: <Widget>[

            ClipPath(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/admin.jpeg"),
                      fit: BoxFit.cover),
                ),
              ),
              clipper: Header(),
            ),
            Container(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                padding: const EdgeInsets.all(4.0),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                children: _events.map((title) {
                  return Container(
                    child: GestureDetector(
                      onTap: () {
                        if(title=="Social")
                          Navigator.pushNamed(context, SOCIAL_BUSINESS);
                        else if(title=="Employment")
                          Navigator.pushNamed(context, EMPLOYMENT_SUPPORT);
                        else if(title=="Mentor Support")
                          Navigator.pushNamed(context, MENTOR_GROUPS);
                      },
                      child: Card(
                        margin: EdgeInsets.all(25.0),
                        color: Colors.white.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0.3,
                        child: HomeCards(title: title),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
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
    var path = new Path();
    path.lineTo(0.0, size.height - 20.0);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2.25, size.height - 30);
    path.quadraticBezierTo(size.width - (size.width / 3.25), size.height - 65,
        size.width, size.height - 40);
    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
