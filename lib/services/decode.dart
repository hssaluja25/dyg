import 'package:encrypt/encrypt.dart';

/// decryptionKey is used for decrypting the input.
/// It must be the same as encryptionKey.
/// The input must be a base 64 encoded string.
String decrypt({required String decryptionKey, required String input}) {
  final key = Key.fromUtf8(decryptionKey);
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));
  final decrypted = encrypter.decrypt64(input, iv: iv);
  return decrypted;
}
