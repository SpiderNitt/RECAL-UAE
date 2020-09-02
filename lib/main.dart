import 'dart:async';

import 'package:flutter/services.dart';
import 'package:iosrecal/Home/BusinessDatabase.dart';
import 'package:iosrecal/Home/BusinessScreen.dart';
import 'package:iosrecal/Home/DealsExecuted.dart';
import 'package:iosrecal/Home/Feedback.dart';
import 'package:iosrecal/Home/MemberDatabase.dart';
import 'package:iosrecal/Home/SocialMedia.dart';
import 'package:iosrecal/Home/SocialScreen.dart';
import 'package:iosrecal/Home/WriteToMentor.dart';
import 'package:iosrecal/Home/AlumniPlaced.dart';
import 'package:iosrecal/Home/OpenPositions.dart';
import 'package:iosrecal/Home/SeekGuidance.dart';
import 'package:iosrecal/Home/NotificationMenu.dart';
import 'package:iosrecal/Profile/EditProfile.dart';
import 'Support/WriteAdmin.dart';
import 'Constant/Constant.dart';
import 'Constant/Constant.dart';
import 'Home/MarketSurvey.dart';
import 'Home/SeekGuidance.dart';
import 'Home/WriteResume.dart';
import 'Home/LinkedInProfiles.dart';
import 'Home/MentorGroups.dart';
import 'Home/EmploymentSupport.dart';
import 'Profile/ProfileScreen.dart';
import './Constant/Constant.dart';
import './Screen/HomePage.dart';
import './Screen/ImageSplashScreen.dart';
import 'package:flutter/material.dart';
import './UserAuth/Login.dart';
import './Home/MarketSurvey.dart';
import './Home/Feedback.dart';
import './Home/SocialMedia.dart';
import 'Support/supportScreen.dart';
import 'Support/TechnicalSupport.dart';
import 'Support/Volunteer.dart';
import 'Support/Other.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(new MaterialApp(
        title: 'Recal UAE',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ImageSplashScreen(),
        routes: <String, WidgetBuilder>{
          LOGIN_SCREEN: (BuildContext context) => new Login(),
          HOME_PAGE: (BuildContext context) => new HomePage(),
          IMAGE_SPLASH: (BuildContext context) => new ImageSplashScreen(),
          PROFILE_SCREEN: (BuildContext context) => new ProfileScreen(),
          EDIT_PROFILE_SCREEN: (BuildContext context) => new EditProfileScreen(),
          SOCIAL: (BuildContext context) => new SocialScreen(),
          BUSINESS: (BuildContext context) => new BusinessScreen(),
          EMPLOYMENT_SUPPORT: (BuildContext context) => new EmploymentSupport(),
          MENTOR_GROUPS: (BuildContext context) => new MentorGroups(),
          MEMBER_LINKEDIN: (BuildContext context) => new LinkedIn(),
          FEED_BACK: (BuildContext context) => new FeedbackScreen(),
          SOCIAL_MEDIA: (BuildContext context) => new SocialMediaScreen(),
          WRITE_MENTOR: (BuildContext context) => new WriteMentorScreen(),
          WRITE_RESUME_SCREEN: (BuildContext context) => new WriteResume(),
          OPEN_POSITIONS: (BuildContext context) => new OpenPositions(),
          ALUMNI_PLACED_SCREEN: (BuildContext context) => new AlumniPlaced(),
          MARKET_SURVEY: (BuildContext context) => new SurveyScreen(),
          WRITE_TO_ADMIN: (BuildContext context) => new WriteAdmin(),
          SEEK_GUIDANCE: (BuildContext context) => new SeekGuidanceScreen(),
          MEMBER_DATABASE: (BuildContext context) => new MemberDatabase(),
          SUPPORT_SCREEN: (BuildContext context) => new SupportScreen(),
          TECHNICAL_SUPPORT: (BuildContext context) => new TechnicalSupport(),
          VOLUNTEER_SUPPORT: (BuildContext context) => new VolunteerScreen(),
          OTHER_SUPPORT: (BuildContext context) => new OtherScreen(),
          BUSINESS_DATABASE: (BuildContext context) => new BusinessDatabase(),
          DEALS_EXECUTED: (BuildContext context) => new DealsExecuted(),
          NOTIFICATION_MENU: (BuildContext context) => new NotificationsMenu(),
          PICTURE_SCREEN: (BuildContext context) => new PictureScreen(),
        }));
  });
}
