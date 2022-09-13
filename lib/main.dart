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

  @override
  void initState() {
    () async {
      if (await storage.containsKey(key: 'accessToken')) {
        final String encryptedRefreshToken =
            await storage.read(key: 'refreshToken') ?? '';
        final String encryptedAccessToken =
            await storage.read(key: 'accessToken') ?? '';

        setState(
          () {
            refreshToken = decrypt(
              decryptionKey: config.encryptionKeyForRefreshToken,
              input: encryptedRefreshToken,
            );
          },
        );
        setState(
          () {
            accessToken = decrypt(
              decryptionKey: config.encryptionKeyForAccessToken,
              input: encryptedAccessToken,
            );
          },
        );
      } else {
        setState(() => loginIsDoneOnce = false);
      }
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // We have done this because since we are using Futures, even when accessToken is not obtained, still the build method is called.
    // Hence, by using accessToken!=null, we can ensure that everything in the initState() has been executed.
    if (accessToken != null) {
      return MaterialApp(
        title: 'Dyg',
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: loginIsDoneOnce == false
              ? const OnboardingPage()
              : HomePage(
                  accessToken: accessToken ?? '',
                  refreshToken: refreshToken ?? '',
                ),
        ),
      );
    } else {
      return Container(
        color: Color(0xFFF2C4C2),
      );
    }
  }
}
