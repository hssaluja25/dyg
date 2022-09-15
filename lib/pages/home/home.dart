import 'package:flutter/material.dart';
import 'package:spotify/pages/widgets/card.dart';
import 'package:spotify/services/API/fetch_top_tracks.dart';

class HomePage extends StatefulWidget {
  HomePage({required this.accessToken, required this.refreshToken});
  final String accessToken;
  final String refreshToken;

  @override
  State<HomePage> createState() =>
      _HomePageState(accessToken: accessToken, refreshToken: refreshToken);
}

class _HomePageState extends State<HomePage> {
  _HomePageState({required this.accessToken, required this.refreshToken});
  final String accessToken;
  final String refreshToken;

  @override
  void initState() {
    super.initState();
    () async {
      findTopTracks(accessToken: accessToken, refreshToken: refreshToken);
    }();
  }

  // We would need to use either a FutureBuilder or use the same logic as in the main.dart file (Using ternary operators)
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Color(0xFFF2C4C2),
        child: cardCreate(width: width),
      ),
    );
  }
}
