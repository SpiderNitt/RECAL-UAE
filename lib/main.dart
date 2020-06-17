import 'dart:async';

import 'package:flutter/services.dart';
import 'Home/LinkedInProfiles.dart';
import 'Home/MentorGroups.dart';
import 'Home/EmploymentSupport.dart';
import 'Home/HomeScreen.dart';
import 'Home/SocialBusinessScreen.dart';
import 'Profile/ProfileScreen.dart';
import './Constant/Constant.dart';
import './Screen/HomePage.dart';
import './Screen/ImageSplashScreen.dart';
import 'package:flutter/material.dart';
import './UserAuth/Login.dart';

void main()  {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_)  {
        runApp(new MaterialApp(
            title: 'Recal UAE',
            debugShowCheckedModeBanner: false,
            theme: new ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: ImageSplashScreen(),
            routes: <String, WidgetBuilder> {
              LOGIN_SCREEN: (BuildContext context) => new Login(),
              HOME_PAGE: (BuildContext context) => new HomePage(),
              IMAGE_SPLASH: (BuildContext context) => new ImageSplashScreen(),
              PROFILE_SCREEN: (BuildContext context) => new ProfileScreen(),
              HOME_SCREEN: (BuildContext context) => new HomeScreen(),
              SOCIAL_BUSINESS: (BuildContext context) => new SocialPage(),
              EMPLOYMENT_SUPPORT: (BuildContext context) => new EmploymentSupport(),
              MENTOR_GROUPS: (BuildContext context) => new MentorGroups(),
              MEMBER_LINKEDIN: (BuildContext context) => new LinkedIn(),

            }
        ));
  });


}

