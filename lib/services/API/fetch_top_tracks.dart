import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:dyg/services/API/reqest_new_access_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../../providers/top_tracks_done.dart';

/// Fetches short term top tracks
/// Returns a list of maps with info about user's top tracks
Future findTopTracks({
  required String accessToken,
  required String refreshToken,
  required BuildContext context,
  required bool mounted,
}) async {
  print("Finding user's top tracks future of FutureBuilder is being executed");
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
    'https://api.spotify.com/v1/me/top/tracks?time_range=short_term&limit=50',
    options: cacheOptions,
  );
  // Note that response.data is not a string but _InternalLinkedHashMap<String, dynamic>. Hence we don't need jsonDecode for this. Instead we use Map.from()
  print(response.data);
  print(response.statusCode);
  if (response.statusCode == 200) {
    final map = Map<String, dynamic>.from(response.data);

    int total = map['items'].length;

    // Stores info for all top tracks
    List<Map<String, String>> topTracks = [];

    // Stores id of user's top 5 tracks. Later used by recommendations page to recommend songs similar to them.
    List<String> ids = [];
    for (int i = 0; i < total; i++) {
      // Stores track name, album art, share link and preview link.
      Map<String, String> trackInfo = {};

      // If this is one of the user's top 5 tracks, then store its id
      if (i < 5) {
        ids.add(map['items'][i]['id']);
      }

      // Add track name
      trackInfo["name"] = map["items"][i]['name'];
      // 300x300 album art. The size of the image is not guaranteed to be 300x300
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

    // Store the ids of user's top 5 songs so that they can be later read by recommendations page.
    // This could have been done better using a proper State Management helper.
    const storage = FlutterSecureStorage();
    await storage.write(key: 'ids', value: ids.join('%2C'));

    if (!mounted) return;
    Provider.of<TopTracksDone>(context, listen: false).topTracksDone = true;
    print('Top tracks done now');

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

    // Recursively call this function again
    return await findTopTracks(
      accessToken: newAccessToken,
      refreshToken: refreshToken,
      context: context,
      mounted: mounted,
    );
  } else {
    print('Error fetching top tracks');
    throw Exception('Error fetching top tracks');
  }
}
