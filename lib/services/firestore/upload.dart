import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyg/services/API/followed_artists.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future upload(
    {required String accessToken, required String refreshToken}) async {
  const storage = FlutterSecureStorage();
  final String userId = await storage.read(key: 'userId') ?? '';
  final userRef =
      FirebaseFirestore.instance.collection('top tracks & artists').doc(userId);

  String? after = '';
  // Stores the final list of followed artists
  List following = [];
  while (after != null) {
    List result = await findFollowingArtists(
        accessToken: accessToken, refreshToken: refreshToken, after: after);
    after = result[result.length - 1];
    following.addAll(result.sublist(0, result.length - 1));
  }

  await userRef.set(
    {
      'following': following,
    },
  );

  // Set the upload time. Before this, user data would not be uploaded.
  await storage.write(
    key: 'uploadTime',
    value: DateTime.now()
        .add(
          const Duration(days: 4),
        )
        .toString(),
  );
}
