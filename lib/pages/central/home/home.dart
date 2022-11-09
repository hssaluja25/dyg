import 'package:dyg/services/firestore/upload.dart';
import 'package:flutter/material.dart';
import 'package:dyg/services/API/fetch_top_artists.dart';
import 'package:dyg/services/API/fetch_top_tracks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import '../components/log_out_button.dart';
import 'widgets/scrolling_area.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {required this.accessToken,
      required this.refreshToken,
      required this.player,
      super.key});
  final AudioPlayer player;
  final String accessToken;
  final String refreshToken;

  // I have done this because widget.accessToken and widget.refreshToken are empty. Confirm it.
  @override
  State<HomePage> createState() => _HomePageState(
      accessToken: accessToken, refreshToken: refreshToken, player: player);
}

class _HomePageState extends State<HomePage> {
  _HomePageState(
      {required this.accessToken,
      required this.refreshToken,
      required this.player});
  final AudioPlayer player;
  final String accessToken;
  final String refreshToken;
  // Whether to show top tracks or top artists
  bool showTopTracks = true;
  late final Future topTracksFuture = findTopTracks(
      accessToken: accessToken,
      refreshToken: refreshToken,
      context: context,
      mounted: mounted);
  late final Future topArtistsFuture =
      findTopArtists(accessToken: accessToken, refreshToken: refreshToken);

  @override
  void initState() {
    super.initState();
    () async {
      const storage = FlutterSecureStorage();
      // On app install, upload time would not be in the storage (it is set in the upload function which has not yet been executed.)
      // Using the following conditional, the if condition below would be satified
      String time =
          await storage.read(key: 'uploadTime') ?? DateTime.now().toString();
      DateTime uploadTime = DateTime.parse(time);
      DateTime crtTime = DateTime.now();
      // Upload user's followed artists every day, 3 seconds after the app is launched
      if (crtTime.isAfter(uploadTime)) {
        Future.delayed(
          const Duration(seconds: 3),
          () => upload(
            accessToken: widget.accessToken,
            refreshToken: widget.refreshToken,
          ),
        );
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: showTopTracks ? topTracksFuture : topArtistsFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // The first condition is important when we need to refresh
        // access tokens
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          // This list would contain either user's top tracks or top artists
          // depending on what the user wants
          print("Inside home's FutureBuilder");
          List usersTopList = snapshot.data;
          return Stack(
            children: [
              SvgPicture.asset(
                'assets/images/personalization/bg-design.svg',
                fit: BoxFit.fill,
              ),
              // Log Out Button
              Align(
                alignment: const Alignment(0.9, -0.975),
                child: LogOutButton(mounted: mounted),
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
                    physics: const BouncingScrollPhysics(),
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
          print('There was an error fetching top items');
          print(snapshot.error);
          return Container(
            alignment: Alignment.topCenter,
            color: const Color(0xFFeff1f3),
            child: Image.asset(
              'assets/images/personalization/error.png',
              fit: BoxFit.cover,
            ),
          );
        } else {
          // Loading...
          return Container(
            color: const Color(0xFFF2C4C2),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
