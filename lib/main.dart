import 'dart:async';

import 'package:flutter/services.dart';
import 'screens/Home/BusinessNetworkList.dart';
import 'screens/Home/BusinessScreen.dart';
import 'screens/Home/ClosedPositions.dart';
import 'screens/Home/DealsExecuted.dart';
//import 'screens/Home/Feedback.dart';
import 'screens/Home/SocialNetworkList.dart';
import 'screens/Home/SocialMedia.dart';
import 'screens/Home/SocialScreen.dart';
import 'screens/Home/WriteToMentor.dart';
import 'screens/Home/AlumniPlaced.dart';
import 'screens/Home/OpenPositions.dart';
import 'screens/Home/SeekGuidance.dart';

//import 'screens/Home/WriteAdmin.dart';
import 'screens/Home/NotificationMenu.dart';
import 'screens/Profile/EditProfile.dart';
import 'screens/Support/WriteAdmin.dart';
import 'Constant/Constant.dart';
import 'Constant/Constant.dart';
import 'screens/Home/MarketSurvey.dart';
import 'screens/Home/SeekGuidance.dart';
import 'screens/Home/WriteResume.dart';
import 'screens/Home/LinkedInProfiles.dart';
import 'screens/Home/MentorGroups.dart';
import 'screens/Home/EmploymentSupport.dart';
import 'screens/Profile/ProfileScreen.dart';
import 'screens/Profile/EditProfile.dart';
import './Constant/Constant.dart';
import 'screens/Screen/HomePage.dart';
import 'screens//Screen/ImageSplashScreen.dart';
import 'package:flutter/material.dart';
import 'screens/UserAuth/Login.dart';
import 'screens/Support/supportScreen.dart';
import 'screens/Support/TechnicalSupport.dart';
import 'screens/Support/Volunteer.dart';
import 'screens/Support/Other.dart';
import 'screens/Support/Feedback.dart';

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
          FEEDBACK_SUPPORT: (BuildContext context) => new FeedbackScreen(),
          SOCIAL_MEDIA: (BuildContext context) => new SocialMediaScreen(),
          WRITE_MENTOR: (BuildContext context) => new WriteMentorScreen(),
          WRITE_RESUME_SCREEN: (BuildContext context) => new WriteResume(),
          OPEN_POSITIONS: (BuildContext context) => new OpenPositions(),
          CLOSED_POSITIONS: (BuildContext context) => new ClosedPositions(),
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
