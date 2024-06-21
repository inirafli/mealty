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
    await _db
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(cartItem.foodId)
        .set(cartItem.toMap());
  }

  Future<void> updateCartItemQuantity(String userId, CartItem cartItem) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(cartItem.foodId)
        .update(cartItem.toMap());
  }

  Future<void> removeFromCart(String userId, String foodId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(foodId)
        .delete();
  }

  Future<List<CartItem>> getCartItems(String userId) async {
    QuerySnapshot snapshot =
        await _db.collection('users').doc(userId).collection('cart').get();
    return snapshot.docs
        .map((doc) => CartItem.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> clearCart(String userId) async {
    final cartItems =
        await _db.collection('users').doc(userId).collection('cart').get();
    for (var doc in cartItems.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> createOrder(String buyerId, String sellerId,
      List<CartItem> items, int totalPrice) async {
    final orderId = 'order-${generateRandomId(8)}';
    final orderRef = _db.collection('orders').doc(orderId);

    final order = FoodOrder(
      orderId: orderId,
      buyerId: buyerId,
      sellerId: sellerId,
      foodItems: items,
      status: 'pending',
      totalPrice: totalPrice,
      orderRating: 0,
      orderDate: Timestamp.now(),
    );

    await orderRef.set(order.toMap());

    await _db.collection('users').doc(buyerId).update({
      'pendingOrders': FieldValue.arrayUnion([orderId]),
    });

    await _db.collection('users').doc(sellerId).update({
      'pendingOrders': FieldValue.arrayUnion([orderId]),
    });
  }

  Future<void> updateOrderStatus(
    String orderId,
    String newStatus,
    FoodOrder order,
  ) async {
    final orderRef = _db.collection('orders').doc(orderId);

    final buyerRef = _db.collection('users').doc(order.buyerId);
    final sellerRef = _db.collection('users').doc(order.sellerId);

    final batch = _db.batch();

    if (newStatus == 'completed') {
      batch.update(orderRef, {
        'status': newStatus,
        'completionDate': Timestamp.now(),
      });

      batch.update(buyerRef, {
        'pendingOrders': FieldValue.arrayRemove([orderId]),
        'purchases': FieldValue.arrayUnion([orderId]),
      });

      batch.update(sellerRef, {
        'pendingOrders': FieldValue.arrayRemove([orderId]),
        'sales': FieldValue.arrayUnion([orderId]),
      });

      for (var item in order.foodItems) {
        final foodDoc = await _db.collection('foods').doc(item.foodId).get();
        final foodType = foodDoc['category'];

        batch.update(buyerRef, {
          'completedFoodTypes.$foodType': FieldValue.increment(item.quantity),
        });

        batch.update(sellerRef, {
          'completedFoodTypes.$foodType': FieldValue.increment(item.quantity),
        });
      }
    } else {
      batch.update(orderRef, {'status': newStatus});
    }

    await batch.commit();
  }

  Future<List<FoodOrder>> getOrdersByBuyerId(String buyerId) async {
    QuerySnapshot snapshot = await _db
        .collection('orders')
        .where('buyerId', isEqualTo: buyerId)
        .get();
    return snapshot.docs
        .map((doc) => FoodOrder.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<FoodOrder>> getOrdersBySellerId(String sellerId) async {
    QuerySnapshot snapshot = await _db
        .collection('orders')
        .where('sellerId', isEqualTo: sellerId)
        .get();
    return snapshot.docs
        .map((doc) => FoodOrder.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addOrderRating(String orderId, int rating) async {
    final orderRef = _db.collection('orders').doc(orderId);

    await orderRef.update({
      'orderRating': rating,
    });

    final orderSnapshot = await orderRef.get();
    final order =
        FoodOrder.fromMap(orderSnapshot.data() as Map<String, dynamic>);

    final sellerRef = _db.collection('users').doc(order.sellerId);
    final sellerSnapshot = await sellerRef.get();
    final sellerData = sellerSnapshot.data() as Map<String, dynamic>;

    final currentRating = sellerData['starRating'] ?? 0;
    final countRating = sellerData['countRating'] ?? 0;

    final newRating =
        ((currentRating * countRating) + rating) / (countRating + 1);

    await sellerRef.update({
      'starRating': newRating,
      'countRating': countRating + 1,
    });
  }
}
