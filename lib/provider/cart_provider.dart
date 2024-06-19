import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/model/cart.dart';
import '../data/model/food_post.dart';
import '../services/firestore_services.dart';
import '../widgets/common/custom_snackbar.dart';

class CartProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<CartItem> _cartItems = [];

  CartProvider() {
    loadCartItems();
  }

  List<CartItem> get cartItems => _cartItems;

  Future<void> loadCartItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _cartItems = await _firestoreService.getCartItems(user.uid);
      notifyListeners();
    }
  }

  void addToCart(FoodPost post, BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final existingIndex = _cartItems.indexWhere((item) => item.foodId == post.id);

    if (existingIndex != -1) {
      if (_cartItems[existingIndex].quantity < post.stock) {
        _cartItems[existingIndex].quantity += 1;
        await _firestoreService.updateCartItemQuantity(user.uid, _cartItems[existingIndex]);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            contentText: 'Tidak bisa menambahkan jumlah melebihi stok!',
            context: context,
          ),
        );
      }
    } else {
      final cartItem = CartItem(
        foodId: post.id,
        quantity: 1,
        price: post.price,
      );
      _cartItems.add(cartItem);
      await _firestoreService.addToCart(user.uid, cartItem);
    }
    notifyListeners();
  }

  void updateCartItemQuantity(String id, int quantity, int stock, BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final index = _cartItems.indexWhere((item) => item.foodId == id);

    if (index != -1) {
      if (quantity <= stock) {
        _cartItems[index].quantity = quantity;
        await _firestoreService.updateCartItemQuantity(user.uid, _cartItems[index]);
        notifyListeners();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            contentText: 'Tidak bisa menambahkan jumlah melebihi stok!',
            context: context,
          ),
        );
      }
    }
  }

  void removeFromCart(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _cartItems.removeWhere((item) => item.foodId == id);
    await _firestoreService.removeFromCart(user.uid, id);
    notifyListeners();
  }

  double get totalPrice {
    return _cartItems.fold(0, (sum, item) => sum + (item.quantity * item.price));
  }
}