import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../services/API/authenticate.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SvgPicture.asset(
              'assets/images/login/bg-design.svg',
              fit: BoxFit.fill,
            ),
            Align(
              alignment: const Alignment(0, 0.2),
              child: Image.asset('assets/images/login/center-image.png'),
            ),
            Align(
              alignment: const Alignment(0, 0.7),
              child: Material(
                child: InkWell(
                  onTap: () => authenticate(context: context),
                  child: Ink(
                    color: const Color(0xffE9EFFF),
                    child: SvgPicture.asset('assets/images/login/button.svg'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
