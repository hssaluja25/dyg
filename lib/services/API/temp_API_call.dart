import 'package:http/http.dart' as http;

void tempCall(String accessToken) async {
  final Uri uri =
      Uri.parse('https://api.spotify.com/v1/tracks/6aDsgHPZsMztSbZernzlF8');
  final response = await http.get(
    uri,
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('Api call failed.');
    print(response.statusCode);
    print(response.body);
  }
}
