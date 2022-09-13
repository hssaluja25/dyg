import 'package:flutter/material.dart';
import 'package:spotify/pages/widgets/card.dart';
import 'package:spotify/services/API/fetch_top_tracks.dart';

class HomePage extends StatelessWidget {
  HomePage({required this.accessToken, required this.refreshToken});
  final String accessToken;
  final String refreshToken;

  @override
  Widget build(BuildContext context) {
    findTopTracks(accessToken: accessToken, refreshToken: refreshToken);
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
