import 'followed_artists.dart';

/// Finds artists user follows. It calls findFollowingArtists helper function.
Future<List> getFollowing(
    {required String accessToken, required String refreshToken}) async {
  String? after = '';
  // Stores the final list of followed artists
  List following = [];
  while (after != null) {
    List result = await findFollowingArtists(
        accessToken: accessToken, refreshToken: refreshToken, after: after);
    after = result[result.length - 1];
    following.addAll(result.sublist(0, result.length - 1));
  }
  return following;
}
