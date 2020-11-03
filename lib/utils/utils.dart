import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Utils {
  static String formatDateTime(DateTime date) {
    final DateFormat formatter = DateFormat('dd MMM yy, hh:mm aa');
    return formatter.format(date);
  }

  static String contentPreview(String content) {
    if (content.length < 50) {
      return content;
    }
    return content.substring(0, 50) + ' ...';
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
    return TextStyle(fontSize: 15, fontWeight: FontWeight.w200);
  }
}
