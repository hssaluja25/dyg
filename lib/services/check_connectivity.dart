import 'dart:io';

Future<bool> checkInternetConnection() async {
  try {
    // If user is not connected to an internet connection, the following would
    // throw an error which would be caught by snapshot.hasError part of FutureBuilder
    // in home.dart
    final result = await InternetAddress.lookup('example.com')
        .timeout(const Duration(seconds: 2));
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('Connected to the internet');
    }
    return true;
  } on SocketException catch (_) {
    return false;
  }
}
