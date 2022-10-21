import 'package:dyg/pages/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({
    Key? key,
    required this.mounted,
  }) : super(key: key);

  final bool mounted;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        print('Logging out');
        print('Deleting (encrypted) access and refresh tokens');
        const storage = FlutterSecureStorage();
        await storage.deleteAll();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const OnboardingPage(),
          ),
        );
      },
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: const Color(0xFFc2f0f2),
        foregroundColor: Colors.black,
      ),
      child: const Text(
        'Log Out',
        style: TextStyle(
          fontFamily: 'Syne',
        ),
      ),
    );
  }
}
