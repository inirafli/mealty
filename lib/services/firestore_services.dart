import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mealty/data/model/user.dart';

import '../data/model/cart.dart';

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

  Future<DocumentSnapshot?> getFoodPostById(String id) async {
    try {
      DocumentSnapshot doc = await _db.collection('foods').doc(id).get();
      return doc.exists ? doc : null;
    } catch (e) {
      rethrow;
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

  Future<void> addToCart(String userId, CartItem cartItem) async {
    await _db.collection('users').doc(userId).collection('cart').doc(cartItem.foodId).set(cartItem.toMap());
  }

  Future<void> updateCartItemQuantity(String userId, CartItem cartItem) async {
    await _db.collection('users').doc(userId).collection('cart').doc(cartItem.foodId).update(cartItem.toMap());
  }

  Future<void> removeFromCart(String userId, String foodId) async {
    await _db.collection('users').doc(userId).collection('cart').doc(foodId).delete();
  }

  Future<List<CartItem>> getCartItems(String userId) async {
    QuerySnapshot snapshot = await _db.collection('users').doc(userId).collection('cart').get();
    return snapshot.docs.map((doc) => CartItem.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }
}
