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
  bool showTopTracks = true;
  bool apiCallDone = false;
  List topTracks = [];
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    () async {
      List<dynamic> doneAndResponse = await findTopTracks(
          accessToken: accessToken, refreshToken: refreshToken);
      setState(() => apiCallDone = doneAndResponse[0]);
      setState(() => topTracks = doneAndResponse[1]);
      print('Done finding top tracks = $apiCallDone');
    }();
    player = AudioPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: apiCallDone
          ? Stack(
              children: [
                SvgPicture.asset(
                  'assets/images/home/bg-design.svg',
                  fit: BoxFit.fill,
                ),
                // Top Tracks textbutton
                Align(
                  alignment: const Alignment(-0.7, -0.6),
                  child: TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.black),
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
                    style: TextButton.styleFrom(foregroundColor: Colors.black),
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
                  child: Container(
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
                            ),
                            CardCreate(
                              width: width,
                              player: player,
                              name: topTracks[1]['name'] ?? '',
                              img: topTracks[1]['img'] ?? '',
                              preview: topTracks[1]['preview'] ?? '',
                              url: topTracks[1]['url'] ?? '',
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
                            ),
                            CardCreate(
                              width: width,
                              player: player,
                              name: topTracks[3]['name'] ?? '',
                              img: topTracks[3]['img'] ?? '',
                              preview: topTracks[3]['preview'] ?? '',
                              url: topTracks[3]['url'] ?? '',
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
                            ),
                            CardCreate(
                              width: width,
                              player: player,
                              name: topTracks[5]['name'] ?? '',
                              img: topTracks[5]['img'] ?? '',
                              preview: topTracks[5]['preview'] ?? '',
                              url: topTracks[5]['url'] ?? '',
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
            )
          : Container(
              color: const Color(0xFFF2C4C2),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
    );
  }
}
