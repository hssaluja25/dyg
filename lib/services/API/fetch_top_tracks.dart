import 'dart:io';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:spotify/services/API/reqest_new_access_token.dart';
import 'decrypt.dart';

import 'package:spotify/services/API/config.dart' as config;

/// Fetches short term top tracks
/// Returns a list of maps with info about user's top tracks
Future findTopTracks({
  required String accessToken,
  required String refreshToken,
}) async {
  print("Finding user's top tracks future of FutureBuilder is being executed");
  // If user is not connected to an internet connection, the following would
  // throw an error which would be caught by snapshot.hasError part of FutureBuilder
  // in home.dart
  final result = await InternetAddress.lookup('example.com')
      .timeout(const Duration(seconds: 2));
  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    print('Connected to the internet');
  }
  final Uri uri = Uri.parse(
      'https://api.spotify.com/v1/me/top/tracks?time_range=short_term&limit=50');
  final response = await http.get(
    uri,
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );
  print(response.body);
  if (response.statusCode == 200) {
    final map = jsonDecode(response.body);

    int total = map['items'].length;

    // Stores info for all top tracks
    List<Map<String, String>> topTracks = [];
    for (int i = 0; i < total; i++) {
      // Stores track name, album art, share link and preview link.
      Map<String, String> trackInfo = {};
      // Add track name ✔
      trackInfo["name"] = map["items"][i]['name'];
      // 300x300 album art
      trackInfo["img"] = map["items"][i]['album']['images'][1]['url'];
      // 640x640 album art
      // trackInfo["img"] = map["items"][0]['album']['images'][0]['url'];
      // 64x64 album art
      // trackInfo["img"] = map["items"][0]['album']['images'][2]['url'];
      // ! Some songs (example Living Life, in the Night) do not have a preview.
      // ! Hence no preview url link.
      trackInfo['preview'] =
          map["items"][i]['preview_url'] ?? 'Preview not available';
      trackInfo["url"] = map['items'][i]['uri'];
      trackInfo["fallbackUrl"] = map["items"][i]['external_urls']['spotify'];

      topTracks.add(trackInfo);
    }
    print('toptracks is $topTracks');
    print('Returning topTracks list');
    return topTracks;
  } else if (response.statusCode == 401) {
    print('Access token expired');
    await requestRefreshedAccessToken(refreshToken: refreshToken);

    // Obtain the new access token from flutter_secure_storage
    // and decrypt it.
    const storage = FlutterSecureStorage();
    final String encryptedAccessToken =
        await storage.read(key: 'accessToken') ?? '';
    String newAccessToken = decrypt(
      decryptionKey: config.encryptionKeyForAccessToken,
      input: encryptedAccessToken,
    );

    // Recursively call this method again
    return await findTopTracks(
      accessToken: newAccessToken,
      refreshToken: refreshToken,
    );
  }
}
