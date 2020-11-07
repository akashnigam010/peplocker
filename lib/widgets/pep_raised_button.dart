import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peplocker/utils/app_colors.dart';

class PepRaisedButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool isLoading;

  const PepRaisedButton({Key key, this.text, this.onPressed, this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      disabledColor: Color(AppColors.black),
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? Container(
              height: 15.0,
              width: 15.0,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                strokeWidth: 1.0,
                valueColor:
                    AlwaysStoppedAnimation<Color>(Color(AppColors.primaryColor)),
              ))
          : Text(
              text,
              style: TextStyle(
                color: Color(AppColors.black),
              ),
            ),
      color: Color(AppColors.primaryColor),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.white24)),
    );
  }
}
