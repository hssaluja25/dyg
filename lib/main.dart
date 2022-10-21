import 'package:dyg/pages/central/central.dart';
import 'package:dyg/pages/central/home/widgets/no_connection.dart';
import 'package:dyg/services/check_connectivity.dart';
import 'package:flutter/material.dart';
// For setting preferred orientation
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dyg/pages/onboarding/onboarding.dart';
import 'package:dyg/services/API/config.dart' as config;
import 'package:dyg/services/decode.dart';

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
  late final Future obtainTokensFuture = obtainTokens();
  late final Future checkConnectionFuture = checkInternetConnection();

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
          future: checkConnectionFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              // There is internet availability
              if (snapshot.data) {
                return FutureBuilder(
                  future: obtainTokensFuture,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return loginIsDoneOnce == false
                          ? const OnboardingPage()
                          : CentralPage(
                              accessToken: accessToken ?? '',
                              refreshToken: refreshToken ?? '',
                            );
                    } else {
                      print(
                          'Meanwhile, conection state is ${snapshot.connectionState}');
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
                );
              } else {
                // No internet availability
                return const Scaffold(body: NoConnection());
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
