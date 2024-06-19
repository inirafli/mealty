import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String phoneNumber;
  final String photoUrl;
  final int starRating;
  final String username;
  final GeoPoint address;
  final Map<String, dynamic> completedFoodTypes;
  final List<dynamic> orderHistory;
  final List<dynamic> purchases;
  final List<dynamic> sales;
  final List<dynamic> pendingOrders;
  final List<dynamic> postedFoods;

  User({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.photoUrl,
    required this.starRating,
    required this.username,
    required this.address,
    required this.completedFoodTypes,
    required this.orderHistory,
    required this.purchases,
    required this.sales,
    required this.pendingOrders,
    required this.postedFoods,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      email: data['email'],
      phoneNumber: data['phoneNumber'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      starRating: data['starRating'],
      username: data['username'],
      address: data['address'],
      completedFoodTypes: data['completedFoodTypes'],
      orderHistory: data['orderHistory'] ?? [],
      purchases: data['purchases'] ?? [],
      sales: data['sales'] ?? [],
      pendingOrders: data['pendingOrders'] ?? [],
      postedFoods: data['postedFoods'] ?? [],
    );
  }
}