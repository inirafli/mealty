import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mealty/data/model/user.dart';
import 'package:mealty/data/model/food_order.dart';

import '../data/model/cart.dart';
import '../utils/random_id_utils.dart';

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
    final cartItemId = 'cart-${generateRandomId(8)}';
    await _db.collection('users').doc(userId).collection('cart').doc(cartItemId).set(cartItem.toMap());
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

  Future<void> clearCart(String userId) async {
    final cartItems = await _db.collection('users').doc(userId).collection('cart').get();
    for (var doc in cartItems.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> createOrder(String buyerId, String sellerId, List<CartItem> items, int totalPrice) async {
    final orderId = 'order-${generateRandomId(8)}';
    final orderRef = _db.collection('orders').doc(orderId);

    final order = FoodOrder(
      orderId: orderId,
      buyerId: buyerId,
      sellerId: sellerId,
      foodItems: items,
      status: 'pending',
      totalPrice: totalPrice,
      orderDate: Timestamp.now(),
    );

    await orderRef.set(order.toMap());

    await _db.collection('users').doc(buyerId).update({
      'purchases': FieldValue.arrayUnion([orderId]),
      'pendingOrders': FieldValue.arrayUnion([orderId]),
    });

    await _db.collection('users').doc(sellerId).update({
      'pendingOrders': FieldValue.arrayUnion([orderId]),
    });
  }
}
