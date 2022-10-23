import 'package:just_audio/just_audio.dart';

Future play({
  required String preview,
  required AudioPlayer player,
  required int songIndex,
}) async {
  // If there is no currently playing song, this would be null
  final String? currentAudioSource = player.sequenceState?.currentSource?.tag;
  print('Current audio source: $currentAudioSource');
  final String thisCard = 'Song ${songIndex + 1}';

  // Some song is being played
  if (player.playing) {
    // User tapped on same card and song has already finished playing for the complete duration (Note that this still returns player.playing = true even though no song is currently playing.)
    if (currentAudioSource == thisCard &&
        player.playbackEvent.processingState == ProcessingState.completed) {
      player.setAudioSource(
        AudioSource.uri(
          Uri.parse(preview),
          tag: 'Song ${songIndex + 1}',
        ),
      );
      player.play();
    } else if (currentAudioSource == thisCard) {
      // Song was playing and the user tapped on the same card before it could be finished.
      await player.pause();
      print('Now the song is paused');
    } else {
      // User tapped on some other card while the previous song may or may not have finished.
      player.setAudioSource(
        AudioSource.uri(
          Uri.parse(preview),
          tag: 'Song ${songIndex + 1}',
        ),
      );
      player.play();
    }
  }
  // No song is being played
  else {
    // Paused before completion and user tapped on the same card.
    if (currentAudioSource == thisCard) {
      player.play();
    } else {
      print('No song is being played');
      print(
          'This should be executed initially and when song has finished playing');
      player.setAudioSource(
        AudioSource.uri(
          Uri.parse(preview),
          tag: 'Song ${songIndex + 1}',
        ),
      );
      player.play();
    }
  }
}
