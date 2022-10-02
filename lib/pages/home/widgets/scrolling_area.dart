import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../widgets/card.dart';

List<Widget> createScrollingArea(
    {required List topTracks,
    required double width,
    required AudioPlayer player}) {
  int total = topTracks.length;
  print('Number of top songs is $total');
  int rows = total ~/ 2;
  print('Number of rows required is $rows');

  // This list would be passed to ListView
  List<Widget> children = [];
  int currentSong = 0;
  for (int row = 0; row < rows; row++) {
    List<Widget> childrenOfRow = [];
    for (int card = 0; card < 2; card += 1) {
      childrenOfRow.add(
        CardCreate(
          width: width,
          player: player,
          name: topTracks[currentSong]['name'] ?? '',
          img: topTracks[currentSong]['img'] ?? '',
          preview: topTracks[currentSong]['preview'] ?? '',
          url: topTracks[currentSong]['url'] ?? '',
          fallbackUrl: topTracks[currentSong]['fallbackUrl'] ?? '',
        ),
      );
      currentSong += 1;
    }
    children.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: childrenOfRow,
      ),
    );
    children.add(
      const SizedBox(
        height: 20,
      ),
    );
  }
  return children;
}
