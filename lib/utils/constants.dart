class Constants {
  static final String appName = 'Peplocker';
  static final String isFirstLaunch = 'isFirstLaunch';
  static final String driveFolderName = 'Peplocker';
  static final String driveFileName = 'peplocker-notes-db.txt';
  static final String driveFolderMimeType =
      'application/vnd.google-apps.folder';
  static final String changePassword = 'changePassword';
  static final String signOut = 'signOut';
  static final String privacy = 'privacy';
  static final String privacyPolicy =
      'https://peplocker.akashnigam.co.in/privacy.html';
  static final String appLocked = 'App locked, please login again';

  // password error messages and patterns
  static final String emptyPW = 'Please enter the password';
  static final int lengthPWPattern = 8;
  static final String lengthPW = 'Too short! atleast 8 characters required';
  static final lowerCasePWPattern = RegExp('(.*[a-z].*)');
  static final String lowerCasePW = 'You are missing a lower case character';
  static final upperCasePWPattern = RegExp('(.*[A-Z].*)');
  static final String upperCasePW = 'You are missing an upper case character';
  static final numberPWPattern = RegExp('(.*\\d.*)');
  static final String numberPW = 'You are missing a number';
  static final specialCharPWPattern = RegExp('(.*[@#*\$%!^&+=].*)');
  static final String specialCharPW = 'You are missing a special character';
  static final whitespacePWPattern = RegExp('(.*[\\s].*)');
  static final String whitespacePW = 'You have a whitespace in password';
  static final String passwordRules = '''Your password should

. be atleast 8 characters long
. contain a lowercase character
. contain an uppercase character
. contain a number
. contain a special character
. not contain any whitespace''';
  static final String discardNote = '''You made some changes to this note.
Do you want to save them?''';
}
