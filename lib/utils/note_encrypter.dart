import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:peplocker/utils/crypto_constants.dart';

class NoteEncrypter {
  final _iv;
  final Encrypter _encrypter;

  NoteEncrypter._(this._iv, this._encrypter);

  factory NoteEncrypter(String password) {
    Uint8List salt = Uint8List.fromList(CryptoConstants.saltNumList);
    final key = Key.fromUtf8(password).stretch(32, salt: salt);
    final iv = IV.fromUtf8(CryptoConstants.iv);
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
