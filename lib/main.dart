import 'dart:async';

import 'package:flutter/services.dart';
import 'package:iosrecal/screens/Recal/splash/ImageSplashScreen.dart';
import 'package:iosrecal/screens/Home/Employment/pages/JobDetails.dart';
import 'package:iosrecal/screens/Recal/IntroPage.dart';
import 'package:iosrecal/screens/UserAuth/pages/PasswordReset.dart';
import 'screens/Home/Business/pages/BusinessNetworkList.dart';
import 'screens/Home/Business/BusinessScreen.dart';
import 'screens/Home/Employment/pages/ClosedPositions.dart';
import 'screens/Home/Business/pages/DealsExecuted.dart';
//import 'screens/Home/Feedback.dart';
import 'screens/Home/Social/pages/SocialNetworkList.dart';
import 'screens/Home/SocialMedia/SocialMedia.dart';
import 'screens/Home/Social/SocialScreen.dart';
import 'screens/Support/pages/WriteToMentor.dart';
import 'screens/Home/Employment/pages/OpenPositions.dart';

//import 'screens/Home/WriteAdmin.dart';
import 'screens/Home/Message/NotificationMenu.dart';
import 'screens/Profile/pages/EditProfile.dart';
import 'screens/Support/pages/WriteAdmin.dart';
import 'routes.dart';
import 'routes.dart';
import 'screens/Home/Employment/pages/MarketSurvey.dart';
import 'screens/Home/Employment/pages/WriteResume.dart';
import 'screens/Home/Employment/pages/LinkedInProfiles.dart';
import 'screens/Home/Mentorship/MentorGroups.dart';
import 'screens/Home/Employment/EmploymentSupport.dart';
import 'screens/Profile/ProfileScreen.dart';
import 'screens/Profile/pages/EditProfile.dart';
import 'routes.dart';
import 'screens/Recal/home/HomePage.dart';
import 'package:flutter/material.dart';
import 'screens/UserAuth/Login.dart';
import 'screens/Support/SupportScreen.dart';
import 'screens/Support/pages/TechnicalSupport.dart';
import 'screens/Support/pages/Volunteer.dart';
import 'screens/Support/pages/Other.dart';
import 'screens/Support/pages/Feedback.dart';


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
          INTRO_PAGE: (BuildContext context) => new IntroPage(),
          LOGIN_SCREEN: (BuildContext context) => new Login(),
          PASSWORD_RESET: (BuildContext context) => new PasswordReset(),
          HOME_SCREEN: (BuildContext context) => new HomeScreen(),
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
          MARKET_SURVEY: (BuildContext context) => new SurveyScreen(),
          WRITE_TO_ADMIN: (BuildContext context) => new WriteAdmin(),
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
