import 'package:dyg/pages/home/recommendations/components/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../components/log_out_button.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({super.key});

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
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
        Align(
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
        ),
      ],
    );
  }
}
