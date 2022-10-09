import 'package:auto_size_text/auto_size_text.dart';
import 'package:dyg/pages/home/components/share_button.dart';
import 'package:dyg/services/play_preview.dart';
import 'package:flutter/material.dart';
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
                  playPreview(
                      preview: widget.preview,
                      context: context,
                      player: widget.player,
                      songIndex: widget.songIndex);
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
