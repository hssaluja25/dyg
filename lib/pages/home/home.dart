import 'package:flutter/material.dart';
import 'package:spotify/pages/widgets/card.dart';
import 'package:spotify/services/API/fetch_top_tracks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';

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
          future: findTopTracks(
              accessToken: accessToken, refreshToken: refreshToken),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // The first condition is important when we need to refresh
            // access tokens
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              print('Inside ConnectionState.done');
              List topTracks = snapshot.data;
              print('Toptracks value is $topTracks');
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
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CardCreate(
                                width: width,
                                player: player,
                                name: topTracks[0]['name'] ?? '',
                                img: topTracks[0]['img'] ?? '',
                                preview: topTracks[0]['preview'] ?? '',
                                url: topTracks[0]['url'] ?? '',
                                fallbackUrl: topTracks[0]['fallbackUrl'] ?? '',
                              ),
                              CardCreate(
                                width: width,
                                player: player,
                                name: topTracks[1]['name'] ?? '',
                                img: topTracks[1]['img'] ?? '',
                                preview: topTracks[1]['preview'] ?? '',
                                url: topTracks[1]['url'] ?? '',
                                fallbackUrl: topTracks[1]['fallbackUrl'] ?? '',
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CardCreate(
                                width: width,
                                player: player,
                                name: topTracks[2]['name'] ?? '',
                                img: topTracks[2]['img'] ?? '',
                                preview: topTracks[2]['preview'] ?? '',
                                url: topTracks[2]['url'] ?? '',
                                fallbackUrl: topTracks[2]['fallbackUrl'] ?? '',
                              ),
                              CardCreate(
                                width: width,
                                player: player,
                                name: topTracks[3]['name'] ?? '',
                                img: topTracks[3]['img'] ?? '',
                                preview: topTracks[3]['preview'] ?? '',
                                url: topTracks[3]['url'] ?? '',
                                fallbackUrl: topTracks[3]['fallbackUrl'] ?? '',
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CardCreate(
                                width: width,
                                player: player,
                                name: topTracks[4]['name'] ?? '',
                                img: topTracks[4]['img'] ?? '',
                                preview: topTracks[4]['preview'] ?? '',
                                url: topTracks[4]['url'] ?? '',
                                fallbackUrl: topTracks[4]['fallbackUrl'] ?? '',
                              ),
                              CardCreate(
                                width: width,
                                player: player,
                                name: topTracks[5]['name'] ?? '',
                                img: topTracks[5]['img'] ?? '',
                                preview: topTracks[5]['preview'] ?? '',
                                url: topTracks[5]['url'] ?? '',
                                fallbackUrl: topTracks[5]['fallbackUrl'] ?? '',
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
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
