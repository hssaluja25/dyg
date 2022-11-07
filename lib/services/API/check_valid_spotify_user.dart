import 'package:dio/dio.dart';
import 'reqest_new_access_token.dart';

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
    return true;
  } else if (response.statusCode == 404) {
    return false;
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
