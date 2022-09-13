import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ! Some songs do not have a preview. In that case check if map['preview'] == 'Preview not available'.
// ! If so, make a SnackBar: Spotify does not allow preview of this song.
Widget cardCreate({required double width}) {
  final double cardDimension = (width - 20) / 2;
  return SizedBox(
    width: cardDimension,
    height: cardDimension,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      // If you use CircularBorder and you wrap the image (or any other widget)
      // in Card, the child widget won't be clipped according to the Card shape.
      // So you must use use ClipRRect and specify borderRadius. That's it.
      // ClipRRect is a widget that clips its child using a rounded rectangle.
      elevation: 3,
      child: Stack(
        children: [
          // Album Art/Artist Page
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/home/trial.png',
              fit: BoxFit.fill,
            ),
          ),
          // The row at the bottom containing the song track & the share button
          BottomRow(cardDimension: cardDimension),
        ],
      ),
    ),
  );
}

class BottomRow extends StatelessWidget {
  final double cardDimension;
  const BottomRow({required this.cardDimension, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The alignment property of Container aligns its contents. It DOES NOT align the whole container.
    // For that, we need to use the Align widget.
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        child: Container(
          height: cardDimension / 3,
          color: Color.fromARGB(102, 255, 255, 255),
          padding: const EdgeInsets.only(bottom: 5, left: 5, right: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // The track name or the artist name
              Flexible(
                child: Text(
                  // As long as the artist name or the album track consists of at most 57 characters, everythings is all right.
                  'The Prince That Was Promised by Ramind Djawadi and George',
                  style: TextStyle(
                    fontFamily: 'Syne',
                  ),
                ),
              ),
              // The share button
              FaIcon(FontAwesomeIcons.share),
            ],
          ),
        ),
      ),
    );
  }
}
