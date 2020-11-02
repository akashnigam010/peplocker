import 'package:intl/intl.dart';

class Utils {
  static String formatDateTime(DateTime date) {
    final DateFormat formatter = DateFormat('dd MMM yy, hh:mm aa');
    return formatter.format(date);
  }

  static String contentPreview(String content) {
    return content.substring(0, 10) + ' ...';
  }
}
