import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rankit_flutter/objects/list_data.dart';

abstract class FirestoreService {
  static final db = FirebaseFirestore.instance;

  static Future create(String collection, String listId, Map<String, dynamic> data) async {
    await db.collection(collection).doc(listId).set(data);
  }

  static Future<Map<String, dynamic>?> read(String collection, String listId) async {
    final snapshot = await db.collection(collection).doc(listId).get();
    return snapshot.data();
  }

  static Future update(String collection, String listId, Map<String, dynamic> data) async {
    await db.collection(collection).doc(listId).update(data);
  }

  static Future replace(String collection, String listId, Map<String, dynamic> data) async {
    await db.collection(collection).doc(listId).set(data);
  }

  static Future delete(String collection, String listId) async {
    await db.collection(collection).doc(listId).delete();
  }
}