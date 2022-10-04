import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dyg/services/API/reqest_new_access_token.dart';

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
  final response = await Dio().get(
    'https://api.spotify.com/v1/me/top/tracks?time_range=short_term&limit=50',
    options: Options(
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    ),
  );
  // Note that response.data is not a string but _InternalLinkedHashMap<String, dynamic>. Hence we don't need jsonDecode for this. Instead we use Map.from
  print(response.data);
  if (response.statusCode == 200) {
    final map = Map<String, dynamic>.from(response.data);

    int total = map['items'].length;

    // Stores info for all top tracks
    List<Map<String, String>> topTracks = [];
    for (int i = 0; i < total; i++) {
      // Stores track name, album art, share link and preview link.
      Map<String, String> trackInfo = {};
      // Add track name
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
    bool odd = total % 2 == 0 ? false : true;
    // We don't want odd number of top tracks
    if (odd) {
      topTracks.removeAt(total - 1);
    }
    print('toptracks is $topTracks');
    print('Returning topTracks list');
    return topTracks;
  } else if (response.statusCode == 401) {
    print('Access token expired');
    String newAccessToken =
        await requestRefreshedAccessToken(refreshToken: refreshToken);

    // Recursively call this method again
    return await findTopTracks(
      accessToken: newAccessToken,
      refreshToken: refreshToken,
    );
  }
}
