import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'dart:io';
import 'package:dyg/services/API/reqest_new_access_token.dart';

/// Fetches short term (4 weeks) top artists
/// Returns a list of maps with info about user's top artists
findTopArtists({
  required String accessToken,
  required String refreshToken,
}) async {
  print("Finding user's top artists future of FutureBuilder is being executed");
  // If user is not connected to an internet connection, the following would
  // throw an error which would be caught by snapshot.hasError part of FutureBuilder
  // in home.dart
  final result = await InternetAddress.lookup('example.com')
      .timeout(const Duration(seconds: 2));
  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    print('Connected to the internet');
  }

  DioCacheManager dcm = DioCacheManager(CacheConfig());
  Options cacheOptions = buildCacheOptions(
    const Duration(hours: 1),
    options: Options(
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    ),
  );
  Dio dio = Dio();
  dio.interceptors.add(dcm.interceptor);

  final response = await dio.get(
    'https://api.spotify.com/v1/me/top/artists?time_range=short_term&limit=50',
    options: cacheOptions,
  );
  print(response.data);
  if (response.statusCode == 200) {
    final map = Map<String, dynamic>.from(response.data);

    int total = map['items'].length;

    // Stores info for all top artists
    List<Map<String, String>> topArtists = [];
    for (int i = 0; i < total; i++) {
      // Stores artist name, image links, share link (their page).
      Map<String, String> artistInfo = {};
      // Add artist name
      artistInfo["name"] = map["items"][i]["name"];
      // 320x320 image
      artistInfo["img"] = map["items"][i]['images'][1]['url'];
      artistInfo["url"] = map["items"][i]["uri"];
      artistInfo["fallbackUrl"] = map["items"][i]['external_urls']['spotify'];

      topArtists.add(artistInfo);
    }
    bool odd = total % 2 == 0 ? false : true;
    // We don't want odd number of top tracks
    if (odd) {
      topArtists.removeAt(total - 1);
    }
    print('topartists is $topArtists');
    print('Returning topArtists list');
    return topArtists;
  } else if (response.statusCode == 401) {
    print('Access token expired');
    String newAccessToken =
        await requestRefreshedAccessToken(refreshToken: refreshToken);

    // Recursively call this method again
    return await findTopArtists(
      accessToken: newAccessToken,
      refreshToken: refreshToken,
    );
  }
}
