import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> getFoodPosts() async {
    try {
      QuerySnapshot snapshot = await _db.collection('foods').get();
      return snapshot.docs;
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> getUser(String userId) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }
}
