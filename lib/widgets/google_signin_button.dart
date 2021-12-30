import 'package:flutter/material.dart';

class GoogleSigninButton extends StatelessWidget {
  final Function onPressed;
  const GoogleSigninButton({Key key, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: InkWell(
        onTap: onPressed,
        child: Image.asset('assets/images/btn_google_signin.png'),
      ),
    );
  }
}
