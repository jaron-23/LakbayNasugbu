
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static Future<Map<String, dynamic>?> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final userDoc = _firestore.collection('users').doc(user.uid);
    final snapshot = await userDoc.get();
    final data = snapshot.data();

    final favorites = List<String>.from(
      data?['favorites'] ?? const <String>[],
    );

    final itinerary = List<String>.from(
      data?['itinerary'] ?? const <String>[],
    );

    await userDoc.set({
      'favorites': favorites,
      'itinerary': itinerary,
    }, SetOptions(merge: true));

    return {
      'favorites': favorites,
      'itinerary': itinerary,
    };
  }

  static Future<void> saveUserData(
      Map<String, dynamic> changes,
      ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(changes, SetOptions(merge: true));
  }

  static Future<void> addFavorite(String name) async {
    await saveUserData({
      'favorites': FieldValue.arrayUnion([name]),
    });
  }

  static Future<void> removeFavorite(String name) async {
    await saveUserData({
      'favorites': FieldValue.arrayRemove([name]),
    });
  }

  static Future<void> addToItinerary(String name) async {
    await saveUserData({
      'itinerary': FieldValue.arrayUnion([name]),
    });
  }

  static Future<void> removeFromItinerary(String name) async {
    await saveUserData({
      'itinerary': FieldValue.arrayRemove([name]),
    });
  }
}
