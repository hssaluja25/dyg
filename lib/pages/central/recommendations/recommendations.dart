import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'components/horizontal_scrolling_area.dart';
import '../../../services/API/fetch_recommendations.dart';
import '../../../services/API/recommend_genre.dart';
import '../../../providers/top_tracks_done.dart';
import '../components/log_out_button.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage(
      {required this.accessToken,
      required this.refreshToken,
      required this.player,
      super.key});
  final String accessToken;
  final String refreshToken;
  final AudioPlayer player;

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState(
      accessToken: accessToken, refreshToken: refreshToken, player: player);
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  _RecommendationsPageState(
      {required this.accessToken,
      required this.refreshToken,
      required this.player});
  final AudioPlayer player;
  final String accessToken;
  final String refreshToken;
  late final Future fetchRecommendationsFuture = fetchRecommendations(
    accessToken: accessToken,
    refreshToken: refreshToken,
  );
  // Used by ListView.builder
  List<String> listOfRecommendations = [
    'Recommended',
    'acoustic',
    'edm',
    'happy',
    'indian',
    'jazz',
    'k-pop',
    'metal',
    'pop',
    'rock',
    'romance',
    'sad',
    'work-out',
  ];
  late final List<Future> fetchGenreFutures = [Future(() => null)];

  @override
  void initState() {
    super.initState();
    for (int i = 1; i < listOfRecommendations.length; i++) {
      fetchGenreFutures.add(
        fetchGenre(
          accessToken: accessToken,
          refreshToken: refreshToken,
          genre: listOfRecommendations[i],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final done = context.watch<TopTracksDone>().topTracksDone;
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        // Background
        SvgPicture.asset(
          'assets/images/recommendations/bg-design.svg',
          fit: BoxFit.fill,
        ),
        // Log Out Button
        Align(
          alignment: const Alignment(0.9, -0.975),
          child: LogOutButton(mounted: mounted),
        ),
        // All recommendations
        Positioned(
          top: 200,
          bottom: 0,
          left: 0,
          right: 0,
          child:
              // Returns Column(heading, scrollingArea)
              ListView.builder(
            physics: const BouncingScrollPhysics(),
            addAutomaticKeepAlives: false,
            cacheExtent: 100,
            itemCount: 13,
            itemBuilder: (BuildContext context, int index) {
              Container headingText;
              Widget scrollingArea;
              if (index == 0) {
                headingText = Container(
                  margin: const EdgeInsets.only(left: 15, bottom: 5, top: 20),
                  child: const Text(
                    'Recommended for you',
                    style: TextStyle(
                      fontFamily: 'SyneBold',
                      fontSize: 22,
                    ),
                  ),
                );
                // Horizontal Scrolling Area
                scrollingArea = done
                    ? FutureBuilder(
                        future: fetchRecommendationsFuture,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            print(
                                'Inside Recom. FB: Fetch Recommendations Future Completed');
                            List recommendations = snapshot.data;
                            return SizedBox(
                              height: width / 2,
                              child: ListView(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                cacheExtent: 200,
                                addAutomaticKeepAlives: false,
                                children: addChildren(
                                    recommendations: recommendations,
                                    player: player),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: const Text(
                                'Oops! The server cannot currently process this request. Please try again after some time.',
                                style: TextStyle(
                                  fontFamily: 'SyneBold',
                                  fontSize: 16,
                                  color: Colors.redAccent,
                                ),
                              ),
                            );
                          } else {
                            // Loading...
                            return Container(
                              color: const Color(0xFFE9EFFF),
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(),
                            );
                          }
                        },
                      )
                    : Container(
                        color: const Color(0xFFE9EFFF),
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      );
              } else {
                String genre = listOfRecommendations[index];
                String capitalizedGenre =
                    genre[0].toUpperCase() + genre.substring(1);
                headingText = Container(
                  margin: const EdgeInsets.only(left: 15, bottom: 5, top: 20),
                  child: Text(
                    '$capitalizedGenre songs for you',
                    style: const TextStyle(
                      fontFamily: 'SyneBold',
                      fontSize: 22,
                    ),
                  ),
                );
                // Horizontal Scrolling Area
                scrollingArea = FutureBuilder(
                  future: fetchGenreFutures[index],
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      print(
                          'Inside Recom. FB: $capitalizedGenre song future completed');
                      List recommendations = snapshot.data;
                      return SizedBox(
                        height: width / 2,
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          cacheExtent: 200,
                          addAutomaticKeepAlives: false,
                          children: addChildren(
                              recommendations: recommendations, player: player),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: const Text(
                          'Oops! The server cannot currently process this request. Please try again after some time.',
                          style: TextStyle(
                            fontFamily: 'SyneBold',
                            fontSize: 16,
                            color: Colors.redAccent,
                          ),
                        ),
                      );
                    } else {
                      // Loading...
                      return Container(
                        color: const Color(0xFFE9EFFF),
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      );
                    }
                  },
                );
              }
              Column column = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headingText,
                  scrollingArea,
                  // After the last recommendation, there should be some whitespace
                  index == 12 ? const SizedBox(height: 10) : Container(),
                ],
              );
              return column;
            },
          ),
        ),
      ],
    );
  }
}
