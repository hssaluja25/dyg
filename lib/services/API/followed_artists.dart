import 'package:dio/dio.dart';
import 'package:dyg/services/API/reqest_new_access_token.dart';

// If the number of followed artists is greater than the limit (50), then `after` query
// is required to find the remaining artists.
Future<List> findFollowingArtists({
  required String accessToken,
  required String refreshToken,
  required String after,
}) async {
  print("Finding artists user follows");
  final response = await Dio().get(
    after == ''
        ? 'https://api.spotify.com/v1/me/following?type=artist&limit=50'
        : 'https://api.spotify.com/v1/me/following?type=artist&limit=50&after=$after',
    options: Options(
      validateStatus: (_) => true,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    ),
  );
  if (response.statusCode != 200) {
    print(response.data);
    print(response.statusCode);
  }
  if (response.statusCode == 200) {
    final map = Map<String, dynamic>.from(response.data);
    final total = map['artists']['items'].length;
    List following = [];
    for (int index = 0; index < total; index++) {
      final String name = map['artists']['items'][index]['name'];
      // 640x640
      final String img = map['artists']['items'][index]['images'][0]['url'];
      following.add(
        {
          'name': name,
          'img': img,
        },
      );

      // 320x320
      // final img = map['artists']['items'][index]['images'][1];
      // 160x160
      // final img = map['artists']['items'][index]['images'][2];
    }
    final String? after = map['artists']['cursors']['after'];
    following.add(after);
    // 👆 If after is null (all values have been exhausted), the caller would not make the API call again.
    return following;
  } else if (response.statusCode == 401) {
    print('Access token expired');
    String newAccessToken =
        await requestRefreshedAccessToken(refreshToken: refreshToken);

    // Recursively call this function again
    return await findFollowingArtists(
      accessToken: newAccessToken,
      refreshToken: refreshToken,
      after: after,
    );
  } else {
    print('Error finding following artists');
    throw Exception('Error finding following artists');
  }
}
