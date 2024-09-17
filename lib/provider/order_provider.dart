import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

import '../data/model/food_order.dart';
import '../services/firestore_services.dart';
import '../utils/fake_data_generator.dart';
import '../utils/pdf_generator.dart';

class OrderProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  User? _user;
  List<FoodOrder> _buyerOrders = [];
  List<FoodOrder> _sellerOrders = [];
  List<FoodOrder> _originalBuyerOrders = [];
  List<FoodOrder> _originalSellerOrders = [];
  bool _isLoading = true;
  String _filter = 'all';
  int _selectedRating = 5;
  String? _errorMessage;
  String _filterDate = 'allDate';
  DateTime? _startDate;
  DateTime? _endDate;

  OrderProvider() {
    _user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      if (_user != null) {
        _fetchOrders();
      } else {
        _clearOrders();
      }
    });
  }

  List<FoodOrder> get buyerOrders {
    return _applyFilter(
        _isLoading ? FakeDataGenerator.generateFakeOrders() : _buyerOrders);
  }

  List<FoodOrder> get sellerOrders {
    return _applyFilter(
        _isLoading ? FakeDataGenerator.generateFakeOrders() : _sellerOrders);
  }

  bool get isLoading => _isLoading;

  String get filter => _filter;

  int get selectedRating => _selectedRating;

  String? get errorMessage => _errorMessage;

  String get filterDate => _filterDate;

  DateTime? get startDate => _startDate;

  DateTime? get endDate => _endDate;

  Future<void> _fetchOrders() async {
    _isLoading = true;
    notifyListeners();
    if (_user != null) {
      _originalBuyerOrders =
          await _firestoreService.getOrdersByBuyerId(_user!.uid);
      _originalSellerOrders =
          await _firestoreService.getOrdersBySellerId(_user!.uid);
      _buyerOrders = List.from(_originalBuyerOrders);
      _sellerOrders = List.from(_originalSellerOrders);
      _isLoading = false;
      notifyListeners();
    }
  }

  void _clearOrders() {
    _buyerOrders = [];
    _sellerOrders = [];
    notifyListeners();
  }

  Future<void> refreshOrders() async {
    await _fetchOrders();
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

  void setDateFilter(
      {required String filter, DateTime? startDate, DateTime? endDate}) {
    _filterDate = filter;
    _startDate = startDate;
    _endDate = endDate;
    if (filter == '7days' || filter == '15days' || filter == '30days') {
      final int days = int.parse(filter.replaceAll('days', ''));
      final DateTime endDate = DateTime.now();
      final DateTime startDate = endDate.subtract(Duration(days: days));
      filterOrders(startDate, endDate);
    } else if (filter == 'customDate') {
      filterOrders(startDate, endDate);
    } else {
      _buyerOrders = List.from(_originalBuyerOrders);
      _sellerOrders = List.from(_originalSellerOrders);
    }
    notifyListeners();
  }

  void filterOrders(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      _buyerOrders = List.from(_originalBuyerOrders);
      _sellerOrders = List.from(_originalSellerOrders);
      notifyListeners();
      return;
    }

    _buyerOrders = _originalBuyerOrders
        .where((order) =>
            order.orderDate.toDate().isAfter(startDate) &&
            order.orderDate.toDate().isBefore(endDate))
        .toList();
    _sellerOrders = _originalSellerOrders
        .where((order) =>
            order.orderDate.toDate().isAfter(startDate) &&
            order.orderDate.toDate().isBefore(endDate))
        .toList();

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
    try {
      final order = _buyerOrders.firstWhere((order) => order.orderId == orderId,
          orElse: () => _sellerOrders.firstWhere(
              (order) => order.orderId == orderId,
              orElse: () => throw 'Order not found'));
      await _firestoreService.updateOrderStatus(orderId, newStatus, order);
      await _fetchOrders();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> submitOrderRatingAndReview(
      String orderId, String foodId, int rating, String reviewMessage) async {
    final effectiveReviewMessage =
        reviewMessage.isEmpty ? ratingMessage : reviewMessage;
    await _firestoreService.addOrderRating(orderId, rating);
    await _firestoreService.addFoodReview(
        foodId, _user!.uid, effectiveReviewMessage, rating);
    await _fetchOrders();
  }

  Future<void> downloadSummary(
      BuildContext context, DateTime startDate, DateTime endDate) async {
    if (_buyerOrders.where((order) => order.status == 'completed').isEmpty &&
        _sellerOrders.where((order) => order.status == 'completed').isEmpty) {
      _errorMessage =
          'Sepertinya kamu belum pernah melakukan Pembelian atau Penjualan.';
      notifyListeners();
      return;
    }

    final filteredBuyerOrders = _originalBuyerOrders
        .where((order) =>
            order.status == 'completed' &&
            order.orderDate.toDate().isAfter(startDate) &&
            order.orderDate.toDate().isBefore(endDate))
        .toList();

    final filteredSellerOrders = _originalSellerOrders
        .where((order) =>
            order.status == 'completed' &&
            order.orderDate.toDate().isAfter(startDate) &&
            order.orderDate.toDate().isBefore(endDate))
        .toList();

    if (filteredBuyerOrders.isEmpty && filteredSellerOrders.isEmpty) {
      _errorMessage =
          'Tidak ada pesanan yang selesai dalam rentang tanggal ini.';
      notifyListeners();
      return;
    }

    final pdfGenerator = PDFGenerator(_firestoreService);
    final currentUser = await _firestoreService.getUser(_user!.uid);
    final pdfFile = await pdfGenerator.generateSummaryPDF(
      currentUser,
      filteredBuyerOrders,
      filteredSellerOrders,
    );

    OpenFilex.open(pdfFile.path);
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
}
