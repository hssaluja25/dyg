import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// key is required for storage because it stores both access token
/// as well as refresh token which would have different keys.
void store({required String key, required String input}) async {
  const storage = FlutterSecureStorage();
  await storage.write(key: key, value: input);
}
