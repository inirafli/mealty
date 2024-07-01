import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/firestore_services.dart';

class NotificationProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<String> _notifications = [];
  User? _user;

  List<String> get notifications => _notifications;

  NotificationProvider() {
    _user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      if (_user != null) {
        _listenForFoodPosts();
        _listenForOrders();
        _listenForSellerOrders();
      }
    });
  }

  void _listenForFoodPosts() {
    if (_user == null) return;
    _firestoreService.getFoodPostsStream(_user!.uid).listen((foodPosts) {
      final now = Timestamp.now();
      for (var post in foodPosts) {
        if (post.saleTime.compareTo(now) < 0 && post.stock > 0) {
          _notifications.add(
              'Stok makanan "${post.name}" masih ada, tetapi waktu jual telah habis.');
        } else if (post.stock == 0 && post.saleTime.compareTo(now) > 0) {
          _notifications.add(
              'Stok makanan "${post.name}" habis, tetapi waktu jual masih tersisa.');
        }
      }
      notifyListeners();
    });
  }

  void _listenForOrders() {
    if (_user == null) return;
    _firestoreService.getOrdersStream(_user!.uid).listen((orders) {
      for (var order in orders) {
        if (order.status == 'confirmed') {
          _notifications.add('Pesanan Anda telah dikonfirmasi.');
        } else if (order.status == 'canceled') {
          _notifications.add('Pesanan Anda telah dibatalkan.');
        }
      }
      notifyListeners();
    });
  }

  void _listenForSellerOrders() {
    if (_user == null) return;
    _firestoreService.getSellerOrdersStream(_user!.uid).listen((orders) {
      for (var order in orders) {
        if (order.status == 'pending') {
          _notifications.add('Pesanan baru perlu dikonfirmasi.');
        }
      }
      notifyListeners();
    });
  }
}
