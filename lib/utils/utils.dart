import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:peplocker/utils/app_colors.dart';
import 'package:peplocker/utils/constants.dart';

class PasswordValidation {
  final bool hasError;
  final String errorMessage;
  PasswordValidation(this.hasError, this.errorMessage);
}

enum AlertLevel { SUCCESS, ERROR, WARNING }

class Utils {
  static PasswordValidation checkPassword(String password) {
    bool hasError = false;
    String error;
    if (password.isEmpty) {
      hasError = true;
      error = Constants.emptyPW;
    } else if (password.length < Constants.lengthPWPattern) {
      hasError = true;
      error = Constants.lengthPW;
    } else if (!Constants.lowerCasePWPattern.hasMatch(password)) {
      hasError = true;
      error = Constants.lowerCasePW;
    } else if (!Constants.upperCasePWPattern.hasMatch(password)) {
      hasError = true;
      error = Constants.upperCasePW;
    } else if (!Constants.numberPWPattern.hasMatch(password)) {
      hasError = true;
      error = Constants.numberPW;
    } else if (!Constants.specialCharPWPattern.hasMatch(password)) {
      hasError = true;
      error = Constants.specialCharPW;
    } else if (Constants.whitespacePWPattern.hasMatch(password)) {
      hasError = true;
      error = Constants.whitespacePW;
    }
    return new PasswordValidation(hasError, error);
  }

  static String formatDateTime(DateTime date) {
    final DateFormat formatter = DateFormat('dd MMM yy, hh:mm aa');
    return formatter.format(date);
  }

  static void toast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(AppColors.greyBlack),
        textColor: Color(AppColors.primaryColor),
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
  }

  static String titlePreview(String title) {
    String trimmedTitle = title.trim();
    if (trimmedTitle.length < 40) {
      return trimmedTitle;
    }
    return trimmedTitle.substring(0, 40) + ' ...';
  }

  static String contentPreview(String content) {
    String trimmedContent = content.trim();
    if (trimmedContent.length < 120) {
      return trimmedContent;
    }
    return trimmedContent.substring(0, 120) + ' ...';
  }

  static TextStyle getStyleHeading1() {
    return TextStyle(fontSize: 80, fontWeight: FontWeight.w200);
  }

  static TextStyle getStyleHeading2() {
    return TextStyle(fontSize: 40, fontWeight: FontWeight.w200);
  }

  static TextStyle getStyleHeading3() {
    return TextStyle(fontSize: 25, fontWeight: FontWeight.w200);
  }

  static TextStyle getStyleHeading4() {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.w200);
  }

  static ButtonStyle dismissButtonStyle() {
    var style = ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Color(AppColors.white)),
      foregroundColor:
          MaterialStateProperty.all<Color>(Color(AppColors.greyBlack)),
      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(12.0)),
    );
    return style;
  }

  static Future<void> showSimpleDialog(
      Widget widget, bool dismissable, BuildContext currentContext) async {
    return showDialog<void>(
      context: currentContext,
      barrierDismissible: dismissable,
      builder: (BuildContext context) {
        return AlertDialog(
          content: widget,
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              style: dismissButtonStyle(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<bool> showDetailedDialog(
      AlertLevel alertLevel,
      String heading,
      String text,
      bool dismissable,
      BuildContext _context,
      List<Widget> buttons) async {
    IconData icon;
    switch (alertLevel) {
      case AlertLevel.SUCCESS:
        icon = Icons.check;
        break;
      case AlertLevel.ERROR:
        icon = Icons.dangerous;
        break;
      case AlertLevel.WARNING:
        icon = Icons.warning;
        break;
    }
    return showDialog<bool>(
      context: _context,
      barrierDismissible: dismissable,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(icon),
              Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Text(heading,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color(AppColors.greyBlack)))),
            ],
          ),
          content: Text(text,
              textAlign: TextAlign.left,
              style: TextStyle(color: Color(AppColors.greyBlack))),
          actions: buttons,
        );
      },
    );
  }

  static Widget getFlatButton(String text, Function onPressed) {
    return TextButton(
        child: Text(text), onPressed: onPressed, style: dismissButtonStyle());
  }
}
