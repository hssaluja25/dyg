import 'package:dyg/pages/central/recommendations/components/card.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

List<Widget> addChildren(
    {required List recommendations, required AudioPlayer player}) {
  int total = recommendations.length;
  // This list would be passed to ListView
  List<Widget> children = [const SizedBox(width: 15)];
  for (int index = 0; index < total; index++) {
    children.add(
      RecommendationCard(
          songIndex: index,
          name: recommendations[index]['name'],
          artist: recommendations[index]['artist'],
          albumArt: recommendations[index]['img'],
          preview: recommendations[index]['preview'],
          url: recommendations[index]['url'],
          fallbackUrl: recommendations[index]['fallbackUrl'],
          player: player),
    );
    children.add(
      const SizedBox(width: 15),
    );
  }
  return children;
}
