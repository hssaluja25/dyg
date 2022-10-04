import 'package:flutter/material.dart';
import 'package:spotify/services/API/fetch_top_artists.dart';
import 'package:spotify/services/API/fetch_top_tracks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';

import 'widgets/scrolling_area.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {required this.accessToken, required this.refreshToken, super.key});
  final String accessToken;
  final String refreshToken;

  // I have done this because widget.accessToken and widget.refreshToken are empty. Confirm it.
  @override
  State<HomePage> createState() =>
      _HomePageState(accessToken: accessToken, refreshToken: refreshToken);
}

class _HomePageState extends State<HomePage> {
  _HomePageState({required this.accessToken, required this.refreshToken});
  final String accessToken;
  final String refreshToken;
  // Whether to show top tracks or top artists
  bool showTopTracks = true;
  final AudioPlayer player = AudioPlayer();

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: showTopTracks
              ? findTopTracks(
                  accessToken: accessToken, refreshToken: refreshToken)
              : findTopArtists(
                  accessToken: accessToken, refreshToken: refreshToken),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // The first condition is important when we need to refresh
            // access tokens
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              print('Inside ConnectionState.done');
              // This list would contain either user's top tracks or top artists
              // depending on what the user wants
              List usersTopList = snapshot.data;
              print("User's top list is $usersTopList");
              return Stack(
                children: [
                  SvgPicture.asset(
                    'assets/images/home/bg-design.svg',
                    fit: BoxFit.fill,
                  ),
                  // Top Tracks textbutton
                  Align(
                    alignment: const Alignment(-0.7, -0.6),
                    child: TextButton(
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.black),
                      onPressed: () {
                        setState(() => showTopTracks = true);
                      },
                      child: const Text(
                        'Top Tracks',
                        style: TextStyle(
                          fontFamily: 'SyneBold',
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  // Top Artists textbutton
                  Align(
                    alignment: const Alignment(0.7, -0.6),
                    child: TextButton(
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.black),
                      onPressed: () {
                        setState(() => showTopTracks = false);
                      },
                      child: const Text(
                        'Top Artists',
                        style: TextStyle(
                          fontFamily: 'SyneBold',
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  // Your Top Tracks/Your Top Artists heading
                  Align(
                    alignment: const Alignment(-0.7, -0.4),
                    child: Text(
                      showTopTracks ? 'Your Top Tracks' : 'Your Top Artists',
                      style: const TextStyle(
                        fontFamily: 'SyneBold',
                        fontSize: 24,
                      ),
                    ),
                  ),
                  // Scrolling area
                  Align(
                    alignment: const Alignment(-1, 1),
                    child: SizedBox(
                      width: width,
                      height: 500,
                      child: ListView(
                        cacheExtent: 200,
                        addAutomaticKeepAlives: false,
                        children: createScrollingArea(
                          playPreview: showTopTracks,
                          usersTopList: usersTopList,
                          width: width,
                          player: player,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              print('There was an error executing the future');
              print(snapshot.error);
              return Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Image.asset('assets/images/no_internet.jpg'),
                    ),
                    const Expanded(
                      flex: 2,
                      child: Text(
                        'No Internet Connection',
                        style: TextStyle(
                          fontFamily: 'Syne',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              print('State is:');
              print(snapshot.connectionState);
              return Container(
                color: const Color(0xFFF2C4C2),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
