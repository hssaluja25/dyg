import 'package:dyg/pages/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:dyg/services/API/fetch_top_artists.dart';
import 'package:dyg/services/API/fetch_top_tracks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';

import 'widgets/no_connection.dart';
import 'widgets/scrolling_area.dart';

class PersonalizationPage extends StatefulWidget {
  const PersonalizationPage(
      {required this.accessToken, required this.refreshToken, super.key});
  final String accessToken;
  final String refreshToken;

  // I have done this because widget.accessToken and widget.refreshToken are empty. Confirm it.
  @override
  State<PersonalizationPage> createState() => _PersonalizationPageState(
      accessToken: accessToken, refreshToken: refreshToken);
}

class _PersonalizationPageState extends State<PersonalizationPage> {
  _PersonalizationPageState(
      {required this.accessToken, required this.refreshToken});
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
                  // Log Out Button
                  Align(
                    alignment: const Alignment(0.9, -0.975),
                    child: TextButton(
                      onPressed: () async {
                        print('Logging out');
                        print('Deleting (encrypted) access and refresh tokens');
                        const storage = FlutterSecureStorage();
                        await storage.deleteAll();
                        if (!mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const OnboardingPage(),
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
                    ),
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
                    alignment: const Alignment(-0.7, -0.44),
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
              return const NoConnection();
            } else {
              // Loading...
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
