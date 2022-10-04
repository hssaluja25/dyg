import 'package:encrypt/encrypt.dart' as encrypt;

/// encryptionKey length must be of length 32. It is required for encryption.
String encode({required String encryptionKey, required String input}) {
  final key = encrypt.Key.fromUtf8(encryptionKey);
  final iv = encrypt.IV.fromLength(16);
  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  final encrypted = encrypter.encrypt(input, iv: iv);
  return encrypted.base64;
}
