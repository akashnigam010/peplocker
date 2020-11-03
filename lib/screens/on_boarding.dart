import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peplocker/screens/login.dart';
import 'package:peplocker/utils/app_colors.dart';
import 'package:peplocker/utils/constants.dart';
import 'package:peplocker/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(AppColors.black),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Container(
          color: Color(AppColors.primaryColor),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height - 150,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('hi there!', style: Utils.getStyleHeading1()),
                            SizedBox(height: 50.0),
                            Text('i am Peplocker',
                                style: Utils.getStyleHeading2()),
                            SizedBox(height: 80.0),
                            Text(
                                'a simple & secure way to keep your private notes',
                                style: Utils.getStyleHeading3()),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('i am tough!',
                                style: Utils.getStyleHeading2()),
                            SizedBox(height: 80.0),
                            Text(
                                'i keep your notes locked & encrypted in your Google Drive',
                                style: Utils.getStyleHeading3()),
                            SizedBox(height: 80.0),
                            Text(
                                'only you can unlock and see them, not even Google',
                                style: Utils.getStyleHeading3()),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('you are my master!',
                                style: Utils.getStyleHeading2()),
                            SizedBox(height: 80.0),
                            Text('unlock me everytime with my password',
                                style: Utils.getStyleHeading3()),
                            SizedBox(height: 50.0),
                            Text(
                                'but do not forget it as you can\'t recover your notes without it',
                                style: Utils.getStyleHeading3()),
                            SizedBox(height: 50.0),
                            Text(
                                'and when you reinstall the app, use your old password to recover your notes',
                                style: Utils.getStyleHeading4()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomRight,
                    child: FlatButton(
                      onPressed: () async {
                        if (_currentPage != _numPages - 1) {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        } else {
                          final SharedPreferences prefs = await _prefs;
                          prefs.setBool(Constants.isFirstLaunch, false);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            _currentPage != _numPages - 1
                                ? 'next'
                                : 'set password',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
