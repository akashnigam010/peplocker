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
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed))
              return Color(AppColors.primaryColor);
            else if (states.contains(MaterialState.disabled))
              return Color(AppColors.primaryColor);
            return Color(AppColors.primaryColor);
          },
        ),
        minimumSize: MaterialStateProperty.all<Size>(Size(100, 36)),
        padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.only(left: 15.0, right: 15.0)),
        shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: Color(AppColors.black)))),
      ),
      child: isLoading
          ? Container(
              height: 15.0,
              width: 15.0,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                strokeWidth: 1.0,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color(AppColors.black)),
              ))
          : Text(
              text,
              style: TextStyle(
                color: Color(AppColors.black),
              ),
            ),
    );
  }
}
