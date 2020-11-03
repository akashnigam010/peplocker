import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peplocker/screens/login.dart';
import 'package:peplocker/screens/on_boarding.dart';
import 'package:peplocker/screens/splash.dart';
import 'package:peplocker/utils/app_colors.dart';
import 'package:peplocker/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Color(AppColors.primaryColor)));
    return MaterialApp(
      title: 'Peplock',
      theme: ThemeData(
        primaryColor: Color(AppColors.primaryColor),
        scaffoldBackgroundColor: Color(AppColors.white),
        textTheme: GoogleFonts.quicksandTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  bool isLoading = true;
  Widget screen;

  Future<void> setScreen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool(Constants.isFirstLaunch);
    if (isFirstLaunch == null || isFirstLaunch) {
      setState(() {
        isLoading = false;
        screen = OnboardingScreen();
      });
    } else {
      setState(() {
        isLoading = false;
        screen = Login();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setScreen();
    return isLoading ? Splash() : screen;
  }
}
