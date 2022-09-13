import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spotify/services/API/encrypt_store.dart';
import 'config.dart' as config;

/// Once retrieved, access token is stored in flutter_secure_storage.
requestRefreshedAccessToken({required String refreshToken}) async {
  final Uri uri = Uri.parse('https://accounts.spotify.com/api/token');
  final response = await http.post(
    uri,
    body: {
      "client_id": config.clientId,
      "grant_type": "refresh_token",
      "refresh_token": refreshToken,
    },
    headers: {
      "Content_Type": "application/x-www-form-urlencoded",
    },
  );
  if (response.statusCode == 200) {
    Map map = jsonDecode(response.body);

    encryptAndStore(
      encryptionKey: config.encryptionKeyForAccessToken,
      storageKey: 'accessToken',
      input: map['access_token'],
    );
  }
}
