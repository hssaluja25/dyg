import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spotify/services/API/encrypt_store.dart';
import 'config.dart' as config;

/// Once retrieved, encrypted access token is stored in flutter_secure_storage.
Future<bool> requestRefreshedAccessToken({required String refreshToken}) async {
  print('Requesting new access token:');
  print('Refresh token is $refreshToken');
  bool refreshingDone = false;
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
  if (response.statusCode == 200) {
    print('Successfully retrieved new access tokens');
    Map map = jsonDecode(response.body);

    encryptAndStore(
      encryptionKey: config.encryptionKeyForAccessToken,
      storageKey: 'accessToken',
      input: map['access_token'],
    );
    encryptAndStore(
      encryptionKey: config.encryptionKeyForRefreshToken,
      storageKey: 'refreshToken',
      input: map['refresh_token'],
    );
    refreshingDone = true;
  }
  return refreshingDone;
}
