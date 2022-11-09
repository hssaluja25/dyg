import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../API/get_following.dart';

/// Uploads artists user follows to Firestore
Future upload(
    {required String accessToken, required String refreshToken}) async {
  const storage = FlutterSecureStorage();
  final String userId = await storage.read(key: 'userId') ?? '';
  final userRef =
      FirebaseFirestore.instance.collection('top tracks & artists').doc(userId);
  List followedArtists =
      await getFollowing(accessToken: accessToken, refreshToken: refreshToken);

  await userRef.set(
    {
      'following': followedArtists,
    },
  );
  // Set the upload time. Before this, user data would not be uploaded.
  await storage.write(
    key: 'uploadTime',
    value: DateTime.now()
        .add(
          const Duration(days: 1),
        )
        .toString(),
  );
}
