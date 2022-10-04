import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dyg/pages/login/login.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/images/onboarding/bg-design.svg',
            fit: BoxFit.fill,
          ),
          Align(
            alignment: const Alignment(0, 0.2),
            child: Image.asset('assets/images/onboarding/center-image.png'),
          ),
          Align(
            alignment: const Alignment(0, 0.7),
            child: Material(
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const LoginPage(),
                    ),
                  );
                },
                child: Ink(
                  color: const Color(0xffFFCD93),
                  child:
                      SvgPicture.asset('assets/images/onboarding/button.svg'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
