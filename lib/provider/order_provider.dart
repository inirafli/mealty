import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../data/model/food_order.dart';
import '../services/firestore_services.dart';

class OrderProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  User? _user;
  List<FoodOrder> _buyerOrders = [];
  List<FoodOrder> _sellerOrders = [];
  bool _isLoading = true;

  OrderProvider() {
    _user = FirebaseAuth.instance.currentUser;
    _fetchOrders();
  }

  List<FoodOrder> get buyerOrders => _buyerOrders;
  List<FoodOrder> get sellerOrders => _sellerOrders;
  bool get isLoading => _isLoading;

  Future<void> _fetchOrders() async {
    if (_user != null) {
      _buyerOrders = await _firestoreService.getOrdersByBuyerId(_user!.uid);
      _sellerOrders = await _firestoreService.getOrdersBySellerId(_user!.uid);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _firestoreService.updateOrderStatus(orderId, newStatus);
    await _fetchOrders();
  }
}