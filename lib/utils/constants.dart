class Constants {
  static final String appName = 'Peplocker';
  static final String isFirstLaunch = 'isFirstLaunch';
  static final String driveFolderName = 'Peplocker';
  static final String driveFileName = 'peplocker-notes-db.txt';
  static final String driveFolderMimeType = 'application/vnd.google-apps.folder';

  // password error messages and patterns
  static final String emptyPW = 'Please enter the password';
  static final int lengthPWPattern = 16; //mysecurepassword
  static final String lengthPW = 'Too short! atleast 16 characters required';
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
}
