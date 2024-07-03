import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../data/model/notification_items.dart';
import '../services/firestore_services.dart';

class NotificationProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final List<NotificationItem> _notifications = [];
  User? _user;
  bool _isLoading = false;

  List<NotificationItem> get notifications => _notifications;
  bool get isLoading => _isLoading;

  NotificationProvider() {
    _user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      if (_user != null) {
        _clearNotifications();
        fetchNotifications();
        _listenForChanges();
      } else {
        _clearNotifications();
      }
    });
  }

  void _clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _clearNotifications();
    notifyListeners();
    await Future.wait([
      _fetchFoodPosts(),
      _fetchOrders(),
      _fetchSellerOrders(),
    ]);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchFoodPosts() async {
    if (_user == null) return;
    final foodPosts = await _firestoreService.getFoodPostsStream(_user!.uid).first;
    final now = Timestamp.now();
    final newNotifications = <NotificationItem>[];
    for (var post in foodPosts) {
      if (post.saleTime.compareTo(now) < 0 && post.stock > 0) {
        newNotifications.add(NotificationItem(
          category: 'saleIsOver',
          title: 'Waktu Jual Habis',
          description: 'Stok makanan "${post.name}" masih ada, tetapi waktu jual telah habis.',
          icon: MdiIcons.timerAlertOutline,
        ));
      } else if (post.stock == 0 && post.saleTime.compareTo(now) > 0) {
        newNotifications.add(NotificationItem(
          category: 'emptyStock',
          title: 'Stok Habis',
          description: 'Stok makanan "${post.name}" habis, tetapi waktu jual masih tersisa.',
          icon: MdiIcons.packageVariantRemove,
        ));
      }
    }
    _updateNotifications(newNotifications);
  }

  Future<void> _fetchOrders() async {
    if (_user == null) return;
    final orders = await _firestoreService.getOrdersStream(_user!.uid).first;
    final newNotifications = <NotificationItem>[];
    for (var order in orders) {
      if (order.status == 'confirmed') {
        newNotifications.add(NotificationItem(
          category: 'orderConfirmed',
          title: 'Pesanan Dikonfirmasi',
          description: 'Pesanan Anda dengan ID ${order.orderId} telah dikonfirmasi.',
          icon: MdiIcons.basketCheckOutline,
        ));
      } else if (order.status == 'canceled') {
        newNotifications.add(NotificationItem(
          category: 'orderDeclined',
          title: 'Pesanan Ditolak',
          description: 'Pesanan Anda dengan ID ${order.orderId} telah dibatalkan.',
          icon: MdiIcons.basketRemoveOutline,
        ));
      }
    }
    _updateNotifications(newNotifications);
  }

  Future<void> _fetchSellerOrders() async {
    if (_user == null) return;
    final orders = await _firestoreService.getSellerOrdersStream(_user!.uid).first;
    final newNotifications = <NotificationItem>[];
    for (var order in orders) {
      if (order.status == 'pending') {
        newNotifications.add(NotificationItem(
          category: 'orderIn',
          title: 'Pesanan Baru',
          description: 'Ada Pesanan baru yang perlu Anda konfirmasi.',
          icon: MdiIcons.basketPlusOutline,
        ));
      }
    }
    _updateNotifications(newNotifications);
  }

  void _listenForChanges() {
    _listenForFoodPostsChanges();
    _listenForOrdersChanges();
    _listenForSellerOrdersChanges();
  }

  void _listenForFoodPostsChanges() {
    if (_user == null) return;
    _firestoreService.getFoodPostsStream(_user!.uid).listen((foodPosts) {
      fetchNotifications();
    });
  }

  void _listenForOrdersChanges() {
    if (_user == null) return;
    _firestoreService.getOrdersStream(_user!.uid).listen((orders) {
      fetchNotifications();
    });
  }

  void _listenForSellerOrdersChanges() {
    if (_user == null) return;
    _firestoreService.getSellerOrdersStream(_user!.uid).listen((orders) {
      fetchNotifications();
    });
  }

  void _updateNotifications(List<NotificationItem> newNotifications) {
    final existingDescriptions = _notifications.map((n) => n.description).toSet();
    final uniqueNotifications = newNotifications.where((n) => !existingDescriptions.contains(n.description)).toList();

    _notifications.addAll(uniqueNotifications);
    notifyListeners();
  }
}
