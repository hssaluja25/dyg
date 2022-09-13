import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:spotify/services/API/reqest_new_access_token.dart';
import 'package:spotify/services/API/spotify_installed.dart';
import 'decrypt.dart';

import 'package:spotify/services/API/config.dart' as config;

/// Fetches short term top tracks
findTopTracks({
  required String accessToken,
  required String refreshToken,
}) async {
  final Uri uri = Uri.parse(
      'https://api.spotify.com/v1/me/top/tracks?time_range=short_term&limit=30');
  final response = await http.get(
    uri,
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    final map = jsonDecode(response.body);

    // Stores info for all top tracks
    List<Map<String, String>> topTracks = [];
    for (int i = 0; i < 30; i++) {
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

      final spotifyInstalled = await isSpotifyInstalled();

      if (spotifyInstalled) {
        trackInfo["url"] = map['items'][i]['uri'];
      } else {
        trackInfo["url"] = map["items"][i]['external_urls']['spotify'];
      }
      topTracks.add(trackInfo);
    }
  } else if (response.statusCode == 401) {
    requestRefreshedAccessToken(refreshToken: refreshToken);

    // Obtain the new access token from flutter_secure_storage
    // and decrypt it.
    const storage = FlutterSecureStorage();
    final String encryptedAccessToken =
        await storage.read(key: 'accessToken') ?? '';
    accessToken = decrypt(
      decryptionKey: config.encryptionKeyForAccessToken,
      input: encryptedAccessToken,
    );

    // Recursively call this method again
    findTopTracks(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
