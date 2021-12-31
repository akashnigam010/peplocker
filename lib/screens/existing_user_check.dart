import 'package:flutter/material.dart';
import 'package:peplocker/screens/login.dart';
import 'package:peplocker/screens/set_password.dart';
import 'package:peplocker/utils/app_colors.dart';

class ExistingUserCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(AppColors.primaryColor),
      body: Container(
        child: Center(
          child: Container(
            height: height / 2,
            padding: EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text('have you set your password before?',
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w300,
                          color: Color(AppColors.black))),
                ),
                SizedBox(height: 20.0),
                Container(
                  child: Text('or are you reinstalling the app?',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Color(AppColors.black))),
                ),
                SizedBox(height: 40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                      child: Container(
                        child: Text(
                          'yes',
                          style: TextStyle(
                              fontSize: 60.0, color: Color(AppColors.black)),
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SetPassword()),
                        );
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                      child: Container(
                        child: Text(
                          'no',
                          style: TextStyle(
                              fontSize: 60.0, color: Color(AppColors.black)),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
