import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:spotify/services/API/encrypt_store.dart';
import 'config.dart' as config;
import 'decrypt.dart';

/// Once retrieved, encrypted access token is stored in flutter_secure_storage.
Future<dynamic> requestRefreshedAccessToken(
    {required String refreshToken}) async {
  print('Requesting new access token:');
  print('Refresh token is $refreshToken');
  final Uri uri = Uri.parse('https://accounts.spotify.com/api/token');
  final response = await http.post(
    uri,
    body: {
      'client_id': config.clientId,
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken,
    },
    headers: {
      'Content_Type': 'application/x-www-form-urlencoded',
      'Authorization': config.authorization,
    },
  );
  print(response.body);
  if (response.statusCode == 200) {
    print('Successfully retrieved new access tokens');
    Map map = jsonDecode(response.body);

    // Encrypt and store access token for future use (On app restart, this access
    // token would be obtained from storage.)
    String encryptedAccessTokken = encode(
      encryptionKey: config.encryptionKeyForAccessToken,
      input: map['access_token'],
    );
    store(key: 'accessToken', input: encryptedAccessTokken);

    // Encrypt and store refresh token for future use
    String encryptedRefreshToken = encode(
      encryptionKey: config.encryptionKeyForRefreshToken,
      input: map['refresh_token'],
    );
    store(key: 'refreshToken', input: encryptedRefreshToken);
    return map['access_token'];
  }
  // Refresh token has been revoked.
  else if (response.statusCode == 400) {
    print('The refreshToken has been revoked');

    // Let's say the user has not exitted the app for >= 2 hours,
    // After the first hour new refresh token is stored in memory.
    // But the refresh token in parameter is still the same as during initialization.
    // Hence, we obtain new refresh token from storage.
    //
    // Now let's say the user has exitted the app, then the code in this section
    // would never be executed.
    print('Getting new refresh token from storage');
    const storage = FlutterSecureStorage();
    final String encryptedRefreshToken =
        await storage.read(key: 'refreshToken') ?? '';
    String newRefreshToken = decrypt(
      decryptionKey: config.encryptionKeyForRefreshToken,
      input: encryptedRefreshToken,
    );
    print('Is new refresh token same as old?');
    print(newRefreshToken == refreshToken);
    // Once new refresh token has been obtained from storage, use it to obtain new access token
    await requestRefreshedAccessToken(refreshToken: newRefreshToken);
  } else {
    print('There was an error obtaining new access token');
  }
}
