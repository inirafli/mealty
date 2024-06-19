import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/model/cart.dart';
import '../data/model/food_post.dart';
import '../services/firestore_services.dart';
import '../widgets/common/custom_snackbar.dart';

class CartProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<CartItem> _cartItems = [];
  User? _user;
  bool _isLoading = false;

  CartProvider() {
    _user = FirebaseAuth.instance.currentUser;
    loadCartItems();
  }

  List<CartItem> get cartItems => _cartItems;
  bool get isLoading => _isLoading;

  Future<void> loadCartItems() async {
    if (_user != null) {
      _cartItems = await _firestoreService.getCartItems(_user!.uid);
      notifyListeners();
    }
  }

  void addToCart(FoodPost post, BuildContext context) async {
    if (_user == null) return;

    final existingIndex = _cartItems.indexWhere((item) => item.foodId == post.id);

    if (existingIndex != -1) {
      if (_cartItems[existingIndex].quantity < post.stock) {
        _cartItems[existingIndex].quantity += 1;
        await _firestoreService.updateCartItemQuantity(_user!.uid, _cartItems[existingIndex]);
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
      await _firestoreService.addToCart(_user!.uid, cartItem);
    }
    notifyListeners();
  }

  void updateCartItemQuantity(String id, int quantity, int stock, BuildContext context) async {
    if (_user == null) return;

    final index = _cartItems.indexWhere((item) => item.foodId == id);

    if (index != -1) {
      if (quantity <= stock) {
        _cartItems[index].quantity = quantity;
        await _firestoreService.updateCartItemQuantity(_user!.uid, _cartItems[index]);
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
    if (_user == null) return;

    _cartItems.removeWhere((item) => item.foodId == id);
    await _firestoreService.removeFromCart(_user!.uid, id);
    notifyListeners();
  }

  double get totalPrice {
    return _cartItems.fold(0, (sum, item) => sum + (item.quantity * item.price));
  }

  Future<void> placeOrder(BuildContext context) async {
    if (_user == null) return;
    _isLoading = true;
    notifyListeners();

    Map<String, List<CartItem>> sellerOrders = {};

    for (var item in _cartItems) {
      final foodDoc = await _firestoreService.getFoodPostById(item.foodId);
      if (foodDoc != null) {
        final foodData = foodDoc.data() as Map<String, dynamic>;
        final sellerId = foodData['userId'] as String;

        if (sellerOrders.containsKey(sellerId)) {
          sellerOrders[sellerId]!.add(item);
        } else {
          sellerOrders[sellerId] = [item];
        }
      }
    }

    for (var entry in sellerOrders.entries) {
      final sellerId = entry.key;
      final items = entry.value;
      final totalPrice = items.fold(0, (sum, item) => sum + (item.quantity * item.price));
      await _firestoreService.createOrder(_user!.uid, sellerId, items, totalPrice);
    }

    await _firestoreService.clearCart(_user!.uid);

    if(!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(
        contentText: 'Pesanan berhasil dibuat!',
        context: context,
      ),
    );

    _isLoading = false;
    _cartItems.clear();
    notifyListeners();
  }
}