import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// encryptionKey length must be of length 32. It is required for encryption.
///
/// storageKey is required for storing in flutter_secure_storage.
///
/// input is the string to encrypt.
///
/// storageKey is required for the argument because it stores both access token
/// as well as refresh token which would have different storage keys.
void encryptAndStore(
    {required String encryptionKey,
    required String storageKey,
    required String input}) async {
  // Encrypt
  final key = encrypt.Key.fromUtf8(encryptionKey);
  final iv = encrypt.IV.fromLength(16);
  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  final encrypted = encrypter.encrypt(input, iv: iv);
  debugPrint(encrypted.base64);
  // Store
  // Create storage
  const storage = FlutterSecureStorage();
  // Write value
  await storage.write(key: storageKey, value: encrypted.base64);
}
