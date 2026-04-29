import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

/// Logic Summary:
/// Provides the FirebaseFirestore instance.
final firestoreInstanceProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

/// Logic Summary:
/// Provides a single instance of FirestoreService to the entire app.
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  final db = ref.watch(firestoreInstanceProvider);
  return FirestoreService(firestore: db);
});
