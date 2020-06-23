import 'package:flutter/material.dart';
import '../Constant/Constant.dart';
import 'IntroPage.dart';
import 'Walkthrough.dart';

class WalkThroughApp extends StatelessWidget {

  final List<Walkthrough> walk = [
    Walkthrough(
      title: "Welcome to RECAL NIT Trichy",
      content: "Regional Engineering College's Alumni Association",
      imageIcon: Icons.people,
      imagecolor: Colors.blue,
      asset: "assets/images/admin.jpeg",
    ),
    Walkthrough(
      title: "Alumni Events",
      content: "Get details about upcoming events, felicitations and alumni achievements",
      imageIcon: Icons.event,
      imagecolor: Colors.purple,
      asset: "assets/images/feed.jpg",

    ),
    Walkthrough(
      title: "Mentorship",
      content: "Join Mentor Groups, get in touch with young minds.",
      imageIcon: Icons.school,
      imagecolor: Colors.green,
      asset: "assets/images/writementor.jpeg",
    ),
    Walkthrough(
      title: "Employment Support",
      content: "Get latest updates on new job positions and seek guidance from mentors",
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
