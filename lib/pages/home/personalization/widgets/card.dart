import 'package:auto_size_text/auto_size_text.dart';
import 'package:dyg/pages/home/components/share_button.dart';
import 'package:dyg/services/play_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart' as fibs;
import 'package:just_audio/just_audio.dart';

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
  bool isPressed = false;

  @override
  State<CardCreate> createState() => _CardCreateState();
}

class _CardCreateState extends State<CardCreate> {
  @override
  Widget build(BuildContext context) {
    // The first argument sets [dx], the horizontal component, and the second sets [dy], the vertical component
    final Offset offset =
        widget.isPressed ? const Offset(8, 8) : const Offset(2, 2);
    final blur = widget.isPressed ? 6.0 : 5.0;
    return GestureDetector(
      onTap: widget.playPreview
          ? () async {
              if (widget.preview == 'Preview not available') {
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Sorry! Preview not available'),
                    ),
                  );
              } else {
                setState(() => widget.isPressed = !widget.isPressed);
                play(
                    preview: widget.preview,
                    context: context,
                    player: widget.player,
                    songIndex: widget.songIndex);
              }
            }
          : () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: fibs.BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            // The lighter shadow to the top and to the left of the container
            // The shadows should only go inside when the button is pressed.
            fibs.BoxShadow(
              inset: widget.isPressed,
              offset: -offset,
              blurRadius: blur,
              color: const Color(0xFFf8dbda),
            ),
            // The dark shadow below and to the right of the container
            fibs.BoxShadow(
              inset: widget.isPressed,
              blurRadius: blur,
              offset: offset,
              color: const Color(0xFFeb9a97),
            ),
          ],
        ),
        child: SizedBox(
          width: widget.cardDimension,
          height: widget.cardDimension,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: widget.isPressed
                    ? widget.cardDimension - 7
                    : widget.cardDimension,
                maxWidth: widget.isPressed
                    ? widget.cardDimension - 7
                    : widget.cardDimension,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 3,
                child: Stack(
                  children: [
                    // Album Art/Artist Page
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FadeInImage.assetNetwork(
                          placeholder:
                              'assets/images/personalization/placeholder.png',
                          image: widget.img,
                          // Because some images are not the size mentioned in the API documentation.
                          // Recall the BoxFit.fill would not work here because the image is smaller than the container.
                          width: widget.cardDimension,
                          height: widget.cardDimension,
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
          width: cardDimension,
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
                    fontSize: 18,
                  ),
                  maxLines: 3,
                ),
              ),
              // The share button
              ShareButton(url: url, fallbackUrl: fallbackUrl),
            ],
          ),
        ),
      ),
    );
  }
}
