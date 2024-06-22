import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import '../data/model/food_order.dart';
import '../services/firestore_services.dart';
import '../utils/pdf_generator.dart';

class OrderProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  User? _user;
  List<FoodOrder> _buyerOrders = [];
  List<FoodOrder> _sellerOrders = [];
  bool _isLoading = true;
  String _filter = 'all';
  int _selectedRating = 1;
  String? _errorMessage;

  OrderProvider() {
    _user = FirebaseAuth.instance.currentUser;
    _fetchOrders();
  }

  List<FoodOrder> get buyerOrders {
    return _applyFilter(_buyerOrders);
  }

  List<FoodOrder> get sellerOrders {
    return _applyFilter(_sellerOrders);
  }

  bool get isLoading => _isLoading;

  String get filter => _filter;

  int get selectedRating => _selectedRating;

  String? get errorMessage => _errorMessage;

  Future<void> _fetchOrders() async {
    if (_user != null) {
      _buyerOrders = await _firestoreService.getOrdersByBuyerId(_user!.uid);
      _sellerOrders = await _firestoreService.getOrdersBySellerId(_user!.uid);
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  void setSelectedRating(int rating) {
    if (rating < 1) rating = 1;
    _selectedRating = rating;
    notifyListeners();
  }

  String get ratingMessage {
    switch (_selectedRating) {
      case 1:
        return 'Tidak Puas!';
      case 2:
        return 'Cukup Kecewa';
      case 3:
        return 'Biasa Saja';
      case 4:
        return 'Cukup Puas';
      case 5:
        return 'Sangat Puas!';
      default:
        return '';
    }
  }

  List<FoodOrder> _applyFilter(List<FoodOrder> orders) {
    if (_filter == 'all') {
      orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      return orders;
    } else {
      return orders
          .where((order) => order.status == _filter.toLowerCase())
          .toList();
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final order = _buyerOrders.firstWhere((order) => order.orderId == orderId,
        orElse: () => _sellerOrders.firstWhere(
            (order) => order.orderId == orderId,
            orElse: () => throw 'Order not found'));
    await _firestoreService.updateOrderStatus(orderId, newStatus, order);
    await _fetchOrders();
  }

  Future<void> submitOrderRating(String orderId, int rating) async {
    await _firestoreService.addOrderRating(orderId, rating);
    await _fetchOrders();
  }

  Future<void> downloadSummary(BuildContext context) async {
    if (_buyerOrders.where((order) => order.status == 'completed').isEmpty &&
        _sellerOrders.where((order) => order.status == 'completed').isEmpty) {
      _errorMessage =
          'Sepertinya kamu belum pernah melakukan Pembelian atau Penjualan.';
      notifyListeners();
      return;
    }

    final pdfGenerator = PDFGenerator(_firestoreService);
    final currentUser = await _firestoreService.getUser(_user!.uid);
    final pdfFile = await pdfGenerator.generateSummaryPDF(
      currentUser,
      _buyerOrders.where((order) => order.status == 'completed').toList(),
      _sellerOrders.where((order) => order.status == 'completed').toList(),
    );

    OpenFile.open(pdfFile.path);
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
}
