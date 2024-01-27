import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreService {
  static final db = FirebaseFirestore.instance;

  static Future create(String collection, String docId, Map<String, dynamic> data) async {
    await db.collection(collection).doc(docId).set(data);
  }

  static Future<Map<String, dynamic>?> read(String collection, String docId) async {
    final snapshot = await db.collection(collection).doc(docId).get();
    return snapshot.data();
  }

  static Future update(String collection, String docId, Map<String, dynamic> data) async {
    await db.collection(collection).doc(docId).update(data);
  }

  static Future replace(String collection, String docId, Map<String, dynamic> data) async {
    await db.collection(collection).doc(docId).set(data);
  }

  static Future delete(String collection, String docId) async {
    await db.collection(collection).doc(docId).delete();
  }
}