import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class Encryption {
  String encryptMessage(String plainText, String key) {
    final keyBytes = _deriveKey(key);

    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter =
        encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));

    final encrypted = encrypter.encrypt(plainText, iv: iv);

    final resultBytes = iv.bytes + encrypted.bytes;
    return base64Encode(resultBytes);
  }

  String decryptMessage(String encryptedText, String key) {
    final fullEncryptedBytes = base64Decode(encryptedText);

    final ivBytes = fullEncryptedBytes.sublist(0, 16);
    final encryptedBytes = fullEncryptedBytes.sublist(16);

    final keyBytes = _deriveKey(key);
    final iv = encrypt.IV(ivBytes);
    final encrypter =
        encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));

    final decrypted =
        encrypter.decrypt(encrypt.Encrypted(encryptedBytes), iv: iv);
    return decrypted;
  }

  encrypt.Key _deriveKey(String key) {
    final keyBytes = sha256.convert(utf8.encode(key)).bytes;
    return encrypt.Key(Uint8List.fromList(keyBytes));
  }
}
