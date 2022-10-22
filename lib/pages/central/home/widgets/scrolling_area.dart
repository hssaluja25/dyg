import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'card.dart';

List<Widget> createScrollingArea(
    {required bool playPreview,
    required List usersTopList,
    required double width,
    required AudioPlayer player}) {
  int total = usersTopList.length;
  int rows = total ~/ 2;

  // This list would be passed to ListView
  List<Widget> children = [];
  int currentSongOrArtist = 0;
  for (int row = 0; row < rows; row++) {
    List<Widget> childrenOfRow = [];
    for (int card = 0; card < 2; card += 1) {
      childrenOfRow.add(
        CardCreate(
          songIndex: currentSongOrArtist,
          playPreview: playPreview,
          width: width,
          player: player,
          name: usersTopList[currentSongOrArtist]['name'] ?? '',
          img: usersTopList[currentSongOrArtist]['img'] ?? '',
          preview: usersTopList[currentSongOrArtist]['preview'] ?? '',
          url: usersTopList[currentSongOrArtist]['url'] ?? '',
          fallbackUrl: usersTopList[currentSongOrArtist]['fallbackUrl'] ?? '',
        ),
      );
      currentSongOrArtist += 1;
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
