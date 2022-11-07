/// Checks if user exists on Firestore i.e., if user has the app installed
/// If yes, then the results page is opened.
/// Else an error is displayed.
import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> checkUserExists({required String userId}) async {
  print('Checking if user exists on firestore.');
  final userRef =
      FirebaseFirestore.instance.collection('top tracks & artists').doc(userId);
  final snapshot = await userRef.get();
  if (snapshot.exists) {
    print('User exists on firestore');
    return true;
  }
  return false;
}
