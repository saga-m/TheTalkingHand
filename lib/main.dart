import 'package:flutter/material.dart';
import 'package:glove_chat/grid_view_screen/connection_page.dart';
import 'package:glove_chat/grid_view_screen/lesson_page.dart';
import 'package:glove_chat/grid_view_screen/life_track.dart';
import 'package:glove_chat/pages/Splash_Page.dart';
import 'package:glove_chat/pages/home_page.dart';
import 'package:glove_chat/pages/login_page.dart';
import 'package:glove_chat/pages/otp_page.dart';
import 'package:glove_chat/pages/profile_page.dart';
import 'package:glove_chat/pages/signup_page.dart';
import 'grid_view_screen/about_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( const TheTalkingHand());
  // await requestPermissions();
  // await initConnection();
}

class TheTalkingHand extends StatelessWidget {
  const TheTalkingHand({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        SplashPage.id : (context) => SplashPage(),
        LoginPage.id : (context) =>  LoginPage(),
        SignupPage.id : (context) => SignupPage(),
        OtpPage.id : (context) => OtpPage(),
        HomePage.id : (context) => HomePage(),
        ProfilePage.id :(context) => ProfilePage(),
        LessonPage.id :(context) => LessonPage(),
        AboutPage.id :(context) => AboutPage(),
        Bluetooth.id :(context) => Bluetooth(),
        LifeTrack.id :(context) => LifeTrack(),
      },

      initialRoute: 'SplashPage',
    );
  }
}

