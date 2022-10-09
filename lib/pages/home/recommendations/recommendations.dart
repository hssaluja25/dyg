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
          child: ListView(
            physics: const BouncingScrollPhysics(),
            addAutomaticKeepAlives: false,
            cacheExtent: 100,
            children: [
              // Recommended for you text
              Container(
                margin: const EdgeInsets.only(left: 15, bottom: 5, top: 20),
                child: const Text(
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
              Container(
                margin: const EdgeInsets.only(left: 15, bottom: 5, top: 20),
                child: const Text(
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
              // Edm songs for you
              Container(
                margin: const EdgeInsets.only(left: 15, bottom: 5, top: 20),
                child: const Text(
                  'Edm songs for you',
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
                  genre: 'edm',
                ),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    print('Acoustic Song Future Completed');
                    List recommendations = snapshot.data;
                    print("Recommendations: $recommendations");
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
              // Happy songs for you
              Container(
                margin: const EdgeInsets.only(left: 15, bottom: 5, top: 20),
                child: const Text(
                  'Happy songs for you',
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
                  genre: 'happy',
                ),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    print('Acoustic Song Future Completed');
                    List recommendations = snapshot.data;
                    print("Recommendations: $recommendations");
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
              // Indian songs for you
              Container(
                margin: const EdgeInsets.only(left: 15, bottom: 5, top: 20),
                child: const Text(
                  'Indian songs for you',
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
                  genre: 'indian',
                ),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    print('Acoustic Song Future Completed');
                    List recommendations = snapshot.data;
                    print("Recommendations: $recommendations");
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
              // Jazz songs for you
              Container(
                margin: const EdgeInsets.only(left: 15, bottom: 5, top: 20),
                child: const Text(
                  'Jazz songs for you',
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
                  genre: 'jazz',
                ),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    print('Acoustic Song Future Completed');
                    List recommendations = snapshot.data;
                    print("Recommendations: $recommendations");
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
              // K-Pop songs for you
              Container(
                margin: const EdgeInsets.only(left: 15, bottom: 5, top: 20),
                child: const Text(
                  'K-Pop songs for you',
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
                  genre: 'k-pop',
                ),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    print('Acoustic Song Future Completed');
                    List recommendations = snapshot.data;
                    print("Recommendations: $recommendations");
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
              // Metal songs for you
              Container(
                margin: const EdgeInsets.only(left: 15, bottom: 5, top: 20),
                child: const Text(
                  'Metal songs for you',
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
                  genre: 'metal',
                ),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    print('Acoustic Song Future Completed');
                    List recommendations = snapshot.data;
                    print("Recommendations: $recommendations");
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
              // Pop songs for you
              Container(
                margin: const EdgeInsets.only(left: 15, bottom: 5, top: 20),
                child: const Text(
                  'Pop songs for you',
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
                  genre: 'pop',
                ),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    print('Acoustic Song Future Completed');
                    List recommendations = snapshot.data;
                    print("Recommendations: $recommendations");
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
              // Rock songs for you
              Container(
                margin: const EdgeInsets.only(left: 15, bottom: 5, top: 20),
                child: const Text(
                  'Rock songs for you',
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
                  genre: 'rock',
                ),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    print('Acoustic Song Future Completed');
                    List recommendations = snapshot.data;
                    print("Recommendations: $recommendations");
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
              // Romance songs for you
              Container(
                margin: const EdgeInsets.only(left: 15, bottom: 5, top: 20),
                child: const Text(
                  'Romance songs for you',
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
                  genre: 'romance',
                ),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    print('Acoustic Song Future Completed');
                    List recommendations = snapshot.data;
                    print("Recommendations: $recommendations");
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
              // Sad songs for you
              Container(
                margin: const EdgeInsets.only(left: 15, bottom: 5, top: 20),
                child: const Text(
                  'Sad songs for you',
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
                  genre: 'sad',
                ),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    print('Acoustic Song Future Completed');
                    List recommendations = snapshot.data;
                    print("Recommendations: $recommendations");
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
              // Work-Out songs for you
              Container(
                margin: const EdgeInsets.only(left: 15, bottom: 5, top: 20),
                child: const Text(
                  'Work-out songs for you',
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
                  genre: 'work-out',
                ),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    print('Acoustic Song Future Completed');
                    List recommendations = snapshot.data;
                    print("Recommendations: $recommendations");
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
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
