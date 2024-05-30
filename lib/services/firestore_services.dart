import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getFoodPosts() async {
    try {
      QuerySnapshot snapshot = await _db.collection('foods').get();
      List<Map<String, dynamic>> posts = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      return posts;
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
