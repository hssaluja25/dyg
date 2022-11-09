/// Returns an array of maps of common artists as well as MATCH% of user and friend
List compare({required List following, required List friendFollowing}) {
  int numberOfCommonArtists = 0;
  List commonArtists = [];
  for (Map map1 in following) {
    for (Map map2 in friendFollowing) {
      if (map1['name'] == map2['name']) {
        commonArtists.add(map1);
        numberOfCommonArtists += 1;
      }
    }
  }
  int max = following.length > friendFollowing.length
      ? following.length
      : friendFollowing.length;
  // Appending value
  commonArtists.add(numberOfCommonArtists / max * 100);

  return commonArtists;
}
