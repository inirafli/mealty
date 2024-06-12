import 'package:flutter/material.dart';

import '../data/model/cart.dart';
import '../data/model/food_post.dart';
import '../utils/cart_database_helper.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];

  CartProvider() {
    loadCartItems();
  }

  List<CartItem> get cartItems => _cartItems;

  Future<void> loadCartItems() async {
    _cartItems = await CartDatabaseHelper().getCartItems();
    notifyListeners();
  }

  void addToCart(FoodPost post) async {
    final existingIndex = _cartItems.indexWhere((item) => item.id == post.id);

    if (existingIndex != -1) {
      _cartItems[existingIndex].quantity += 1;
      await CartDatabaseHelper().updateCartItem(_cartItems[existingIndex]);
    } else {
      final cartItem = CartItem(
        id: post.id,
        name: post.name,
        price: post.price,
        image: post.image,
        quantity: 1,
      );
      _cartItems.add(cartItem);
      await CartDatabaseHelper().insertCartItem(cartItem);
    }
    notifyListeners();
  }

  void updateCartItemQuantity(String id, int quantity) async {
    final index = _cartItems.indexWhere((item) => item.id == id);

    if (index != -1) {
      _cartItems[index].quantity = quantity;
      await CartDatabaseHelper().updateCartItem(_cartItems[index]);
      notifyListeners();
    }
  }

  void removeFromCart(String id) async {
    _cartItems.removeWhere((item) => item.id == id);
    await CartDatabaseHelper().deleteCartItem(id);
    notifyListeners();
  }

  double get totalPrice {
    return _cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);
  }
}