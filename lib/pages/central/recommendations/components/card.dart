import 'package:dyg/pages/central/components/share_button.dart';
import 'package:dyg/services/play_preview.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class RecommendationCard extends StatefulWidget {
  const RecommendationCard(
      {required this.songIndex,
      required this.name,
      required this.artist,
      required this.albumArt,
      required this.preview,
      required this.url,
      required this.fallbackUrl,
      required this.player,
      super.key});
  final int songIndex;
  final String name;
  final String artist;
  final String albumArt;
  final String preview;
  final String url;
  final String fallbackUrl;
  final AudioPlayer player;

  @override
  State<RecommendationCard> createState() => _RecommendationCardState();
}

class _RecommendationCardState extends State<RecommendationCard> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width / 2 + 30,
      height: width / 2,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        elevation: 3,
        child: InkWell(
          onTap: () async {
            if (widget.preview == 'Preview not available') {
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Sorry! Preview not available'),
                  ),
                );
            } else {
              await play(
                  preview: widget.preview,
                  player: widget.player,
                  songIndex: widget.songIndex);
            }
          },
          borderRadius: BorderRadius.circular(40),
          child: Stack(
            children: [
              // Album Art
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/personalization/placeholder.png',
                  image: widget.albumArt,
                  // Because some images are not the size mentioned in the API documentation.
                  // Recall the BoxFit.fill would not work here because the image is smaller than the container.
                  width: width,
                  height: height,
                ),
              ),
              // Track and Artist name
              Positioned(
                top: 14,
                left: 14,
                right: 14,
                child: Column(
                  children: [
                    // Track Name
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.name,
                            style: TextStyle(
                              backgroundColor: Colors.black.withOpacity(0.6),
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Artist Name
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.artist,
                            style: TextStyle(
                              backgroundColor: Colors.black.withOpacity(0.6),
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: ShareButton(
                      url: widget.url, fallbackUrl: widget.fallbackUrl),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
