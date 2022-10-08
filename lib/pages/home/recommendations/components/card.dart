import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RecommendationCard extends StatelessWidget {
  const RecommendationCard({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width / 2 + 30,
      height: width / 2,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        elevation: 3,
        child: InkWell(
          onTap: () {},
          child: Stack(
            children: [
              // Album Art
              Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://www.scdn.co/i/_global/open-graph-default.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Track and Artist Name
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: Column(
                  children: [
                    // Track Name
                    Row(
                      children: const [
                        Flexible(
                          child: Text(
                            'Track Name ewfhuowhuoewrhuogrgrhurfwuoweuoweuoweuoewf',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Artist Name
                    Row(
                      children: const [
                        Flexible(
                          child: Text(
                            'Artist Name ewruigrhuorewf',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // The share button
              Positioned(
                bottom: 10,
                right: 10,
                child: IconButton(
                  onPressed: () {},
                  icon: const FaIcon(
                    FontAwesomeIcons.share,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
