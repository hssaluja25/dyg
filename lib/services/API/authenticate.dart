import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:dio/dio.dart';
import 'package:pkce/pkce.dart';

import '../../pages/home/personalization/personalization.dart';
import '../encode.dart';
import '../store.dart';
// config contains client ID, authorization, which you should create by
// visiting https://developer.spotify.com/dashboard/applications
// It also contains encryption keys for access and refresh tokens which are just
// random 32 length strings
import 'config.dart' as config;
import '../generate_random_string.dart';

class StateMismatchException implements Exception {
  String message;
  StateMismatchException(this.message);
}

class AuthenticationException implements Exception {
  String message;
  AuthenticationException(this.message);
}

/// BuildContext is required for opening home page
void authenticate({required BuildContext context}) async {
  // App specific variables
  const String clientId = config.clientId;

  final pkcePair = PkcePair.generate();
  final String codeVerifier = pkcePair.codeVerifier;
  final String codeChallenge = pkcePair.codeChallenge;
  final String state = generateRandomString(length: 20);

  String url =
      'https://accounts.spotify.com/authorize?client_id=$clientId&response_type=code&state=$state&redirect_uri=com.analysis.spotify%3A%2F%2Flogin-callback&scope=user-top-read&code_challenge_method=S256&code_challenge=$codeChallenge';

  try {
    // Present the dialog to the user
    final String result = await FlutterWebAuth.authenticate(
      url: url,
      callbackUrlScheme: 'com.analysis.spotify',
    );

    // Extract code from resulting url
    final code = Uri.parse(result).queryParameters['code'] ?? '';
    if (code == '') {
      final error = Uri.parse(result).queryParameters['error'];
      throw AuthenticationException('$error');
    }

    final returnedState = Uri.parse(result).queryParameters['state'];
    if (state != returnedState) {
      throw StateMismatchException(
          'State mismatch between request and callback');
    }

    // Use this authentication code to get an access token
    final response = await Dio().post(
      'https://accounts.spotify.com/api/token/',
      options: Options(
        contentType: 'application/x-www-form-urlencoded',
        headers: {
          "Authorization": config.authorization,
        },
      ),
      data: {
        "grant_type": "authorization_code",
        "code": code,
        "redirect_uri": "com.analysis.spotify://login-callback",
        "client_id": clientId,
        "code_verifier": codeVerifier,
      },
    );

    // Successfully received the access and refresh tokens.
    if (response.statusCode == 200) {
      final map = Map<String, dynamic>.from(response.data);
      final String accessToken = map["access_token"];
      final String refreshToken = map["refresh_token"];
      String encryptedAccessTokken = encode(
        encryptionKey: config.encryptionKeyForAccessToken,
        input: accessToken,
      );
      store(key: 'accessToken', input: encryptedAccessTokken);
      String encryptedRefreshToken = encode(
        encryptionKey: config.encryptionKeyForRefreshToken,
        input: refreshToken,
      );
      store(key: 'refreshToken', input: encryptedRefreshToken);

      openHomePage(
          context: context,
          accessToken: accessToken,
          refreshToken: refreshToken);
    } else {
      throw AuthenticationException('Error obtaining access token');
    }
  } on AuthenticationException catch (error) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(error.message)));
  } on StateMismatchException catch (error) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(error.message)));
  } on PlatformException catch (_) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Login cancelled')));
  }
}

openHomePage(
    {required BuildContext context,
    required String accessToken,
    required String refreshToken}) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) {
        return PersonalizationPage(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      },
    ),
  );
}
