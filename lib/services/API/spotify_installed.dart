import 'package:appcheck/appcheck.dart';
import 'package:flutter/services.dart';

/// Returns true if spotify is installed on user's device.
Future<bool> isSpotifyInstalled() async {
  try {
    const package = "com.spotify.music";
    AppInfo? app = await AppCheck.checkAvailability(package);
  } on PlatformException catch (error) {
    return false;
  }
  return true;
}
