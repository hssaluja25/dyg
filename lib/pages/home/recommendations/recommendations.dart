import 'package:dyg/pages/home/recommendations/components/card.dart';
import 'package:dyg/services/API/fetch_recommendations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../components/log_out_button.dart';
import '../personalization/widgets/no_connection.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage(
      {required this.accessToken, required this.refreshToken, super.key});
  final String accessToken;
  final String refreshToken;

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState(
      accessToken: accessToken, refreshToken: refreshToken);
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  _RecommendationsPageState(
      {required this.accessToken, required this.refreshToken});
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
              print('Future Completed');
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
                    children: const [
                      SizedBox(width: 15),
                      RecommendationCard(),
                      SizedBox(width: 15),
                      RecommendationCard(),
                      SizedBox(width: 15),
                      RecommendationCard(),
                      SizedBox(width: 15),
                      RecommendationCard(),
                      SizedBox(width: 15),
                      RecommendationCard(),
                      SizedBox(width: 15),
                      RecommendationCard(),
                      SizedBox(width: 15),
                    ],
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
