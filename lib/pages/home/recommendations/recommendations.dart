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
      ],
    );
  }
}
