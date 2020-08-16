import 'package:flutter/material.dart';
import '../Constant/Constant.dart';
import 'IntroPage.dart';
import 'Walkthrough.dart';

class WalkThroughApp extends StatelessWidget {

  final List<Walkthrough> walk = [
    Walkthrough(
      title: "Welcome to REC/NIT Trichy Alumni Association",
      content: "(UAE Chapter)",
      imageIcon: Icons.people,
      imagecolor: Colors.blue,
      asset: "assets/images/admin.jpeg",
    ),
    Walkthrough(
      title: "Events",
      content: "Get details about upcoming networking events, felicitations and alumni achievements",
      imageIcon: Icons.event,
      imagecolor: Colors.purple,
      asset: "assets/images/feed.jpg",

    ),
    Walkthrough(
      title: "Mentorship",
      content: "Join our Mentor Groups",
      imageIcon: Icons.school,
      imagecolor: Colors.green,
      asset: "assets/images/writementor.jpeg",
    ),
    Walkthrough(
      title: "Employment",
      content: "Get jobs",
      imageIcon: Icons.work,
      imagecolor: Colors.deepPurpleAccent,
      asset: "assets/images/employment_groups.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    //here we need to pass the list and the route for the next page to be opened after this.
    return new IntroPage(walk,LOGIN_SCREEN);
  }
}
