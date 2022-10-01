import 'package:flutter/material.dart';
// For setting preferred orientation
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotify/pages/onboarding/onboarding.dart';
import 'package:spotify/services/API/config.dart' as config;
import 'package:spotify/services/API/decrypt.dart';
import 'pages/home/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Dyg(),
    ),
  );
}

class Dyg extends StatefulWidget {
  const Dyg({Key? key}) : super(key: key);

  @override
  State<Dyg> createState() => _DygState();
}

class _DygState extends State<Dyg> {
  static const storage = FlutterSecureStorage();
  bool loginIsDoneOnce = true;
  String? accessToken;
  String? refreshToken;

  // @override
  // void initState() {
  //   super.initState();
  //   obtainTokens();
  // }

  Future<void> obtainTokens() async {
    print('Obtaining tokens now');
    if (await storage.containsKey(key: 'accessToken')) {
      print('Access token exists already');
      final String encryptedAccessToken =
          await storage.read(key: 'accessToken') ?? '';
      final String encryptedRefreshToken =
          await storage.read(key: 'refreshToken') ?? '';
      accessToken = decrypt(
        decryptionKey: config.encryptionKeyForAccessToken,
        input: encryptedAccessToken,
      );
      refreshToken = decrypt(
        decryptionKey: config.encryptionKeyForRefreshToken,
        input: encryptedRefreshToken,
      );
      print("Access token is $accessToken");
      print('Refresh token is $refreshToken');
    } else {
      print('Access token does not exist');
      loginIsDoneOnce = false;
      print('loginIsDoneOnce = $loginIsDoneOnce');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Inside build');
    return MaterialApp(
      title: 'Dyg',
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: FutureBuilder(
          future: obtainTokens(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return loginIsDoneOnce == false
                  ? const OnboardingPage()
                  : HomePage(
                      accessToken: accessToken ?? '',
                      refreshToken: refreshToken ?? '',
                    );
            } else {
              print('Conection State is ${snapshot.connectionState}');
              // Waiting for obtain tokens to finish
              return Scaffold(
                body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  color: const Color(0xFFF2C4C2),
                  child: const CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
