import 'package:encrypt/encrypt.dart';

class NoteEncrypter {
  final _iv;
  final _encrypter;

  NoteEncrypter._(this._iv, this._encrypter);

  factory NoteEncrypter(String password) {
    final key = Key.fromUtf8(password);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    return new NoteEncrypter._(iv, encrypter);
  }

  String encrypt(String input) {
    final encrypted = this._encrypter.encrypt(input, iv: this._iv);
    return encrypted.base64;
  }

  String decrypt(String input) {
    final decrypted =
        this._encrypter.decrypt(Encrypted.fromBase64(input), iv: this._iv);
    return decrypted;
  }
}
