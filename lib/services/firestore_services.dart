import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getFoodPosts() async {
    try {
      QuerySnapshot snapshot = await _db.collection('foods').get();
      List<Map<String, dynamic>> posts = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
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
