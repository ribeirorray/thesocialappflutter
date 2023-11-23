import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial1/constants/Constantcolors.dart';
import 'package:thesocial1/screens/AltProfile/alt_profile_helper.dart';
import 'package:thesocial1/screens/Chatroom/Chatroom.dart';
import 'package:thesocial1/screens/Chatroom/ChatroomHelpers.dart';
import 'package:thesocial1/screens/Feed/FeedHelpers.dart';
import 'package:thesocial1/screens/Homepage/HomepageHelpers.dart';
import 'package:thesocial1/screens/LandingPage/landingHelpers.dart';
import 'package:thesocial1/screens/LandingPage/landingPage.dart';
import 'package:thesocial1/screens/LandingPage/landingServices.dart';
import 'package:thesocial1/screens/LandingPage/landingUtils.dart';
import 'package:thesocial1/screens/Messaging/GroupMessagingHelpers.dart';
import 'package:thesocial1/screens/Profile/ProfileHelpers.dart';
import 'package:thesocial1/screens/SplashScreen/Splashscreen.dart';
import 'package:thesocial1/screens/Stories/Stories_Helpers.dart';
import 'package:thesocial1/services/Authentication.dart';
import 'package:thesocial1/services/FirebaseOperations.dart';
import 'package:thesocial1/utils/PostOptions.dart';
import 'package:thesocial1/utils/UploadPost.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return MultiProvider(
        child: MaterialApp(
          home: Splashscreen(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              fontFamily: 'Poppins',
              canvasColor: Colors.transparent,
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: constantColors.blueColor)),
        ),
        providers: [
          ChangeNotifierProvider(create: (_) => StoriesHelper()),
          ChangeNotifierProvider(create: (_) => GroupMessagingHelpers()),
          ChangeNotifierProvider(create: (_) => ChatRoomHelpers()),
          ChangeNotifierProvider(create: (_) => PostFunctions()),
          ChangeNotifierProvider(create: (_) => AltProfileHelpers()),
          ChangeNotifierProvider(create: (_) => ProfileHelpers()),
          ChangeNotifierProvider(create: (_) => FeedHelpers()),
          ChangeNotifierProvider(create: (_) => UploadPost()),
          ChangeNotifierProvider(create: (_) => HomepageHelpers()),
          ChangeNotifierProvider(create: (_) => LandingUtils()),
          ChangeNotifierProvider(create: (_) => FirebaseOperations()),
          ChangeNotifierProvider(create: (_) => LandingService()),
          ChangeNotifierProvider(create: (_) => Authentication()),
          ChangeNotifierProvider(create: (_) => LandingHelpers()),

        ]);
  }
}
