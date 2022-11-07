import 'package:dyg/pages/central/tasteCompate/components/codefield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/log_out_button.dart';

class TasteCompare extends StatefulWidget {
  const TasteCompare(
      {required this.accessToken, required this.refreshToken, super.key});
  final String accessToken;
  final String refreshToken;

  @override
  State<TasteCompare> createState() => _TasteCompareState();
}

class _TasteCompareState extends State<TasteCompare> {
  late final Future getUserIdFromStorage = getIdFromStorage();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserIdFromStorage,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Stack(
              children: [
                // Background
                SvgPicture.asset(
                  'assets/images/tasteCompare/bg-design.svg',
                  fit: BoxFit.fill,
                ),
                // Log Out Button
                Align(
                  alignment: const Alignment(0.9, -0.975),
                  child: LogOutButton(mounted: mounted),
                ),
                // Code field under generate code
                Align(
                  alignment: const Alignment(0.1, -0.05),
                  child: CodeField(
                    btnText: 'Copy',
                    userId: snapshot.data,
                    accessToken: widget.accessToken,
                    refreshToken: widget.refreshToken,
                  ),
                ),
                // Code field under Paste Code
                Align(
                  alignment: const Alignment(0.1, 0.45),
                  child: CodeField(
                    btnText: 'Go!',
                    userId: snapshot.data,
                    accessToken: widget.accessToken,
                    refreshToken: widget.refreshToken,
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Image.asset('assets/images/personalization/error.png');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<String> getIdFromStorage() async {
    const storage = FlutterSecureStorage();
    final String userId = await storage.read(key: 'userId') ?? '';
    return userId;
  }
}
