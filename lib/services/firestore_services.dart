import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mealty/data/model/user.dart';

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

  Future<User> getUser(String userId) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
      return User.fromFirestore(doc);
    } catch (e) {
      rethrow;
    }
  }
}
