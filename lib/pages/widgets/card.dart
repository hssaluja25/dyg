import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';

class CardCreate extends StatefulWidget {
  CardCreate(
      {required this.width,
      required this.name,
      required this.img,
      required this.preview,
      required this.url,
      required this.fallbackUrl,
      required this.player,
      super.key}) {
    cardDimension = (width - 20) / 2;
  }
  final double width;
  final String name;
  final String img;
  final String preview;
  final String url;
  final String fallbackUrl;
  final AudioPlayer player;
  late final double cardDimension;

  @override
  State<CardCreate> createState() => _CardCreateState();
}

class _CardCreateState extends State<CardCreate> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () async {
      //  // ! If i have clicked on some card while the audio is playing, instead of playing the songs simultaneously the previous song should stop.
      //   // Preview NOT playing
      //   if (widget.player.playing == false) {
      //     if (widget.preview != 'Preview not available') {
      //       // Load a URL
      //       final duration = await widget.player.setUrl(widget.preview);
      //       // Play without waiting for completion
      //       widget.player.play();
      //       // * Play while waiting for completion
      //       // await widget.player.play();
      //     } else {
      //       if (!mounted) return;
      //       ScaffoldMessenger.of(context)
      //         ..removeCurrentSnackBar()
      //         ..showSnackBar(const SnackBar(
      //           content: Text('Sorry! Preview not available'),
      //         ));
      //     }
      //   }
      //   // Preview is playing
      //   else if (widget.player.playing == true) {
      //     await widget.player.pause();
      //   }
      // },
      child: SizedBox(
        width: widget.cardDimension,
        height: widget.cardDimension,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          // If you use CircularBorder and you wrap the image (or any other widget)
          // in Card, the child widget won't be clipped according to the Card shape.
          // So you must use use ClipRRect and specify borderRadius. That's it.
          // ClipRRect is a widget that clips its child using a rounded rectangle.
          elevation: 3,
          child: InkWell(
            onTap: () async {
              // ! If i have clicked on some card while the audio is playing, instead of playing the songs simultaneously the previous song should stop.
              // Preview NOT playing
              if (widget.player.playing == false) {
                if (widget.preview != 'Preview not available') {
                  // Load a URL
                  final duration = await widget.player.setUrl(widget.preview);
                  // Play without waiting for completion
                  widget.player.play();
                  // * Play while waiting for completion
                  // await widget.player.play();
                } else {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(const SnackBar(
                      content: Text('Sorry! Preview not available'),
                    ));
                }
              }
              // Preview is playing
              else if (widget.player.playing == true) {
                await widget.player.pause();
              }
            },
            child: Stack(
              children: [
                // Album Art/Artist Page
                Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.img,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // The row at the bottom containing the song track & the share button
                BottomRow(
                  cardDimension: widget.cardDimension,
                  name: widget.name,
                  preview: widget.preview,
                  url: widget.url,
                  fallbackUrl: widget.fallbackUrl,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomRow extends StatelessWidget {
  final double cardDimension;
  const BottomRow(
      {required this.cardDimension,
      required this.name,
      required this.preview,
      required this.url,
      required this.fallbackUrl,
      Key? key})
      : super(key: key);
  final String name;
  final String preview;
  final String url;
  final String fallbackUrl;

  @override
  Widget build(BuildContext context) {
    // The alignment property of Container aligns its contents. It DOES NOT align the whole container.
    // For that, we need to use the Align widget.
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        child: Container(
          height: cardDimension / 3,
          color: const Color.fromARGB(102, 255, 255, 255),
          padding: const EdgeInsets.only(bottom: 5, left: 5, right: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // The track name or the artist name
              Flexible(
                child: Text(
                  // As long as the artist name or the album track consists of at most 57 characters, everythings is all right.
                  name,
                  style: const TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 12,
                  ),
                ),
              ),
              // The share button
              IconButton(
                onPressed: () {
                  final Uri spotifyShareLink = Uri.parse(url);
                  final Uri fallbackUri = Uri.parse(fallbackUrl);
                  () async {
                    if (await canLaunchUrl(spotifyShareLink)) {
                      launchUrl(spotifyShareLink);
                    } else if (await canLaunchUrl(fallbackUri)) {
                      launchUrl(fallbackUri);
                    } else {
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Your device doesn't support opening this type of link"),
                          ),
                        );
                    }
                  }();
                },
                icon: const FaIcon(
                  FontAwesomeIcons.share,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
