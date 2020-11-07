import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peplocker/screens/login.dart';
import 'package:peplocker/utils/constants.dart';

abstract class AppLifecycleAwareState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // app is in background
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login(message: Constants.appLocked,)),
      );
    }
  }
}
