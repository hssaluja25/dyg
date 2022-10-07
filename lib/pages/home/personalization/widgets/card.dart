import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';

class CardCreate extends StatefulWidget {
  CardCreate(
      {required this.songIndex,
      required this.width,
      required this.name,
      required this.img,
      required this.preview,
      required this.url,
      required this.fallbackUrl,
      required this.player,
      required this.playPreview,
      super.key}) {
    cardDimension = (width - 20) / 2;
  }
  final int songIndex;
  final bool playPreview;
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
    return SizedBox(
      width: widget.cardDimension,
      height: widget.cardDimension,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        // If you use CircularBorder and you wrap the image (or any other widget)
        // in Card, the child widget won't be clipped according to the Card shape.
        // So you must use use ClipRRect and specify borderRadius. That's it.
        // ClipRRect is a widget that clips its child using a rounded rectangle.
        elevation: 3,
        child: InkWell(
          onTap: widget.playPreview
              ? () async {
                  if (widget.preview == 'Preview not available') {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text('Sorry! Preview not available'),
                        ),
                      );
                  } else {
                    // If there is no currently playing song, this would be null
                    final String? currentAudioSource =
                        widget.player.sequenceState?.currentSource?.tag;
                    print('Current audio source: $currentAudioSource');
                    final String thisCard = 'Song ${widget.songIndex + 1}';

                    // Some song is being played
                    if (widget.player.playing) {
                      // User tapped on same card and song has already finished playing for the complete duration (Note that this still returns player.playing = true even though no song is currently playing.)
                      if (currentAudioSource == thisCard &&
                          widget.player.playbackEvent.processingState ==
                              ProcessingState.completed) {
                        widget.player.setAudioSource(
                          AudioSource.uri(
                            Uri.parse(widget.preview),
                            tag: 'Song ${widget.songIndex + 1}',
                          ),
                        );
                        widget.player.play();
                      } else if (currentAudioSource == thisCard) {
                        // Song was playing and the user tapped on the same card before it could be finished.
                        await widget.player.pause();
                        print('Now the song is paused');
                      } else {
                        // User tapped on some other card while the previous song may or may not have finished.
                        widget.player.setAudioSource(
                          AudioSource.uri(
                            Uri.parse(widget.preview),
                            tag: 'Song ${widget.songIndex + 1}',
                          ),
                        );
                        widget.player.play();
                      }
                    }
                    // No song is being played
                    else {
                      // Paused before completion and user tapped on the same card.
                      if (currentAudioSource == thisCard) {
                        widget.player.play();
                      } else {
                        print('No song is being played');
                        print(
                            'This should be executed initially and when song has finished playing');
                        widget.player.setAudioSource(
                          AudioSource.uri(
                            Uri.parse(widget.preview),
                            tag: 'Song ${widget.songIndex + 1}',
                          ),
                        );
                        widget.player.play();
                      }
                    }
                  }
                }
              : () {},
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
                url: widget.url,
                fallbackUrl: widget.fallbackUrl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomRow extends StatelessWidget {
  const BottomRow(
      {required this.cardDimension,
      required this.name,
      required this.url,
      required this.fallbackUrl,
      Key? key})
      : super(key: key);
  final double cardDimension;
  final String name;
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
          color: Colors.black.withOpacity(0.6),
          padding: const EdgeInsets.only(bottom: 5, left: 5, right: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // The track name/Artist name
              Expanded(
                child: AutoSizeText(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Syne',
                  ),
                  maxLines: 3,
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
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
