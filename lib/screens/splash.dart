import 'package:flutter/material.dart';
import 'package:peplocker/utils/app_colors.dart';
import 'package:peplocker/utils/constants.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(AppColors.primaryColor),
      body: Container(
        child: Stack(
          children: <Widget>[
            Center(
              child: Text(
                Constants.appName.toUpperCase(),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 15.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
