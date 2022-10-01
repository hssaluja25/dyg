import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// encryptionKey length must be of length 32. It is required for encryption.
String encode({required String encryptionKey, required String input}) {
  final key = encrypt.Key.fromUtf8(encryptionKey);
  final iv = encrypt.IV.fromLength(16);
  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  final encrypted = encrypter.encrypt(input, iv: iv);
  return encrypted.base64;
}

/// key is required for storage because it stores both access token
/// as well as refresh token which would have different keys.
void store({required String key, required String input}) async {
  const storage = FlutterSecureStorage();
  await storage.write(key: key, value: input);
}
