import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  /// Initialize Firebase when the app starts.
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  /// Returns a stream of the card style document.
  static Stream<DocumentSnapshot> getCardStyleStream() {
    return FirebaseFirestore.instance
        .collection('styles')
        .doc('cardStyle')
        .snapshots();
  }
}
