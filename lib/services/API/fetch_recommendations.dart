import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:dyg/services/API/reqest_new_access_token.dart';

Future fetchRecommendations({
  required String accessToken,
  required String refreshToken,
}) async {
  print("Finding recommendations future of FutureBuilder is being executed");
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
    'https://api.spotify.com/v1/recommendations?seed_tracks=5CZ40GBx1sQ9agT82CLQCT%2C7eJMfftS33KTjuF7lTsMCx%2C5wANPM4fQCJwkGd4rN57mH%2C6HU7h9RYOaPRFeh0R3UeAr%2C3nqqDo8CcCLke3ZoTgiOKf',
    options: cacheOptions,
  );
  print(response.data);
  print(response.statusCode);
  print('\n\n');
  if (response.statusCode == 200) {
    final map = Map<String, dynamic>.from(response.data);

    int total = map['tracks'].length;

    List<Map<String, String>> recommendations = [];
    for (int i = 0; i < total; i++) {
      // Stores track name, artist name, album art, share link and preview link
      Map<String, String> trackInfo = {};
      // Add track name
      trackInfo['name'] = map['tracks'][i]['name'];
      trackInfo['artist'] = map['tracks'][i]['artists'][0]['name'];
      // 300x300 album art
      trackInfo['img'] = map['tracks'][i]['album']['images'][1]['url'];
      // 640x640 album art
      // trackInfo["img"] = map['tracks'][0]['album']['images'][0]['url'];
      // 64x64 album art
      // trackInfo["img"] = map['tracks'][0]['album']['images'][2]['url'];
      // ! Some songs (example Living Life, in the Night) do not have a preview.
      // ! Hence no preview url link.
      trackInfo['preview'] =
          map['tracks'][i]['preview_url'] ?? 'Preview not available';
      trackInfo['url'] = map['tracks'][i]['uri'];
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
  }
}
