import 'package:dyg/pages/home/recommendations/components/horizontal_scrolling_area.dart';
import 'package:dyg/services/API/fetch_recommendations.dart';
import 'package:dyg/services/API/recommend_genre.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';

import '../components/log_out_button.dart';
import '../personalization/widgets/no_connection.dart';

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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        SvgPicture.asset(
          'assets/images/recommendations/bg-design.svg',
          fit: BoxFit.fill,
        ),
        // Log Out Button
        Align(
          alignment: const Alignment(0.9, -0.975),
          child: LogOutButton(mounted: mounted),
        ),
        // Recommended for you
        const Align(
          alignment: Alignment(-0.7, -0.4),
          child: Text(
            'Recommended for you',
            style: TextStyle(
              fontFamily: 'SyneBold',
              fontSize: 22,
            ),
          ),
        ),
        // Horizontal Scrolling Area
        FutureBuilder(
          future: fetchRecommendations(
            accessToken: accessToken,
            refreshToken: refreshToken,
          ),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              print('Fetch Recommendations Future Completed');
              List recommendations = snapshot.data;
              print("Recommendations: $recommendations");
              return Align(
                alignment: const Alignment(-0.7, -0.05),
                child: SizedBox(
                  height: width / 2,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    cacheExtent: 200,
                    addAutomaticKeepAlives: false,
                    children: addChildren(
                        recommendations: recommendations, player: player),
                  ),
                ),
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
                color: const Color(0xFFE9EFFF),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }
          },
        ),
        // Acoustic songs for you
        const Align(
          alignment: Alignment(-0.7, 0.33),
          child: Text(
            'Acoustic songs for you',
            style: TextStyle(
              fontFamily: 'SyneBold',
              fontSize: 22,
            ),
          ),
        ),
        // Horizontal Scrolling Area
        FutureBuilder(
          future: fetchGenre(
            accessToken: accessToken,
            refreshToken: refreshToken,
            genre: 'acoustic',
          ),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              print('Acoustic Song Future Completed');
              List recommendations = snapshot.data;
              print("Recommendations: $recommendations");
              return Align(
                alignment: const Alignment(-0.7, 0.78),
                child: SizedBox(
                  height: width / 2,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    cacheExtent: 200,
                    addAutomaticKeepAlives: false,
                    children: addChildren(
                        recommendations: recommendations, player: player),
                  ),
                ),
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
                color: const Color(0xFFE9EFFF),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }
          },
        ),
      ],
    );
  }
}
