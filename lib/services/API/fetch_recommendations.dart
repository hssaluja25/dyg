import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:dyg/services/API/reqest_new_access_token.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future fetchRecommendations({
  required String accessToken,
  required String refreshToken,
}) async {
  print('Fetching recommendations for user...');
  const storage = FlutterSecureStorage();
  String top5TracksIds = await storage.read(key: 'ids') ?? '';

  DioCacheManager dcm = DioCacheManager(CacheConfig());
  Options cacheOptions = buildCacheOptions(
    const Duration(hours: 1),
    options: Options(
      validateStatus: (_) => true,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    ),
  );
  Dio dio = Dio();
  dio.interceptors.add(dcm.interceptor);
  final response = await dio.get(
    'https://api.spotify.com/v1/recommendations?seed_tracks=$top5TracksIds',
    options: cacheOptions,
  );
  if (response.statusCode != 200) {
    print(response.statusCode);
    print(response.data);
  }
  if (response.statusCode == 200) {
    final map = Map<String, dynamic>.from(response.data);

    int total = map['tracks'].length;

    List<Map<String, String>> recommendations = [];
    for (int i = 0; i < total; i++) {
      // Stores track name, artist name, album art, share link and preview link
      Map<String, String> trackInfo = {};
      // Add track name
      trackInfo['name'] = map['tracks'][i]['name'];
      // Add artist name
      trackInfo['artist'] = map['tracks'][i]['artists'][0]['name'];
      // 300x300 album art. The size of the image is not guaranteed to be 300x300
      trackInfo['img'] = map['tracks'][i]['album']['images'][1]['url'];
      // 640x640 album art
      // trackInfo["img"] = map['tracks'][0]['album']['images'][0]['url'];
      // 64x64 album art
      // trackInfo["img"] = map['tracks'][0]['album']['images'][2]['url'];
      // ! Some songs (example Living Life, in the Night) do not have a preview.
      // ! Hence no preview url link.
      trackInfo['preview'] =
          map['tracks'][i]['preview_url'] ?? 'Preview not available';
      // Open in Spotify App
      trackInfo['url'] = map['tracks'][i]['uri'];
      // If Spotify not installed, open in browser
      trackInfo['fallbackUrl'] = map['tracks'][i]['external_urls']['spotify'];

      recommendations.add(trackInfo);
    }
    return recommendations;
  } else if (response.statusCode == 401) {
    print('Access token expired');
    String newAccessToken =
        await requestRefreshedAccessToken(refreshToken: refreshToken);

    // Recursively call this function again
    return await fetchRecommendations(
      accessToken: newAccessToken,
      refreshToken: refreshToken,
    );
  } else {
    print('Error fetching Recommendations for You');
    throw Exception('Error fetching recommendations');
  }
}
