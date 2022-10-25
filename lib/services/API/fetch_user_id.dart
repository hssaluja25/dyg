import 'package:dio/dio.dart';
import 'package:dyg/services/API/reqest_new_access_token.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future fetchUserId({
  required String accessToken,
  required String refreshToken,
}) async {
  print("Finding current user's id");
  final response = await Dio().get(
    'https://api.spotify.com/v1/me',
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
    const storage = FlutterSecureStorage();
    await storage.write(key: 'userId', value: map['id']);
  } else if (response.statusCode == 401) {
    print('Access token expired');
    String newAccessToken =
        await requestRefreshedAccessToken(refreshToken: refreshToken);

    // Recursively call this function again
    await fetchUserId(
      accessToken: newAccessToken,
      refreshToken: refreshToken,
    );
  } else {
    print("Error finding user's id");
    throw Exception("Error finding user's id");
  }
}
