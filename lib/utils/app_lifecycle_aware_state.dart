import 'package:flutter/material.dart';
import 'package:is_lock_screen/is_lock_screen.dart';
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
      navigateToLogin();
    }
  }

  Future<void> navigateToLogin() async {
    bool result = await isLockScreen();
    if (result) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Login(
                    message: Constants.appLocked,
                  )),
          (route) => false);
    }
  }
}
