import 'package:dio/dio.dart';
import 'reqest_new_access_token.dart';

/// Returns
/// * [false] if userId is invalid
/// * [true, friendName, img] is userId is valid
Future checkValidUser({
  required String userId,
  required String accessToken,
  required String refreshToken,
}) async {
  print("Checking if friend's user id is valid");
  final response = await Dio().get(
    'https://api.spotify.com/v1/users/$userId',
    options: Options(
      validateStatus: (_) => true,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    ),
  );
  if (response.statusCode != 200) {
    print(response.statusCode);
    print(response.data);
  }
  if (response.statusCode == 200) {
    print('Valid user id');
    Map map = Map.from(response.data);
    String friendName = map['display_name'];
    String img =
        map['images'].isEmpty ? 'Unavailable' : map['images'][0]['url'];
    return [true, friendName, img];
  } else if (response.statusCode == 404 || response.statusCode == 400) {
    // User id is not valid.
    return [false];
  } else if (response.statusCode == 401) {
    print('Access token expired');
    String newAccessToken =
        await requestRefreshedAccessToken(refreshToken: refreshToken);

    // Recursively call this function again
    return await checkValidUser(
      userId: userId,
      accessToken: newAccessToken,
      refreshToken: refreshToken,
    );
  } else {
    print('Error verifying if user is valid');
    throw Exception('Error verifying if user is valid');
  }
}
