import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotify/services/API/config.dart' as config;
import 'package:spotify/services/API/decrypt.dart';
import 'package:spotify/services/API/reqest_new_access_token.dart';

/// Fetches short term (4 weeks) top artists
findTopArtists(
    {required String accessToken,
    required String refreshToken,
    required bool spotifyInstalled}) async {
  print("Fetching user's top artists");
  final Uri uri = Uri.parse(
      'https://api.spotify.com/v1/me/top/artists?time_range=short_term&limit=50');
  final response = await http.get(
    uri,
    headers: {
      "Authorization": "Bearer $accessToken",
    },
  );
  print(response.body);
  if (response.statusCode == 200) {
    final map = jsonDecode(response.body);

    int total = map['items'].length;

    // Stores info for all top artists
    List<Map<String, String>> topArtists = [];
    for (int i = 0; i < total; i++) {
      // Stores artist name, image links and their page.
      Map<String, String> artistInfo = {};
      // Add artist name
      artistInfo["name"] = map["items"][i]["name"];
      // Add image link
      artistInfo["img"] = map["items"][i]['images'][2]['url'];
      if (spotifyInstalled) {
        artistInfo["url"] = map["items"][i]["uri"];
      } else {
        artistInfo["url"] = map["items"][i]['external_urls']['spotify'];
      }
      topArtists.add(artistInfo);
    }
  } else if (response.statusCode == 401) {
    print('Access token expired');
    await requestRefreshedAccessToken(refreshToken: refreshToken);

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
    return await findTopArtists(
        accessToken: accessToken,
        refreshToken: refreshToken,
        spotifyInstalled: spotifyInstalled);
  }
}
