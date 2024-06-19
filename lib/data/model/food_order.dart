import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mealty/data/model/cart.dart';

class FoodOrder {
  final String orderId;
  final String buyerId;
  final String sellerId;
  final List<CartItem> foodItems;
  final String status;
  final int totalPrice;
  final Timestamp orderDate;
  final Timestamp? completionDate;

  FoodOrder({
    required this.orderId,
    required this.buyerId,
    required this.sellerId,
    required this.foodItems,
    required this.status,
    required this.totalPrice,
    required this.orderDate,
    this.completionDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'foodItems': foodItems.map((item) => item.toMap()).toList(),
      'status': status,
      'totalPrice': totalPrice,
      'orderDate': orderDate,
      'completionDate': completionDate,
    };
  }

  factory FoodOrder.fromMap(Map<String, dynamic> map) {
    return FoodOrder(
      orderId: map['orderId'],
      buyerId: map['buyerId'],
      sellerId: map['sellerId'],
      foodItems: List<CartItem>.from(map['foodItems'].map((item) => CartItem.fromMap(item))),
      status: map['status'],
      totalPrice: map['totalPrice'],
      orderDate: map['orderDate'],
      completionDate: map['completionDate'],
    );
  }
}
