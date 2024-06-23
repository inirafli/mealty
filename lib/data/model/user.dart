import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String phoneNumber;
  final String photoUrl;
  final double starRating;
  final int countRating;
  final String username;
  final GeoPoint address;
  final Map<String, dynamic> completedFoodTypes;
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
    required this.countRating,
    required this.username,
    required this.address,
    required this.completedFoodTypes,
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
      starRating: (data['starRating'] ?? 0).toDouble(),
      countRating: (data['countRating'] ?? 0).toInt(),
      username: data['username'],
      address: data['address'],
      completedFoodTypes: data['completedFoodTypes'],
      purchases: data['purchases'] ?? [],
      sales: data['sales'] ?? [],
      pendingOrders: data['pendingOrders'] ?? [],
      postedFoods: data['postedFoods'] ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'starRating': starRating,
      'countRating': countRating,
      'username': username,
      'address': address,
      'completedFoodTypes': completedFoodTypes,
      'purchases': purchases,
      'sales': sales,
      'pendingOrders': pendingOrders,
      'postedFoods': postedFoods,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      photoUrl: map['photoUrl'],
      starRating: map['starRating'],
      countRating: map['countRating'],
      username: map['username'],
      address: map['address'],
      completedFoodTypes: map['completedFoodTypes'],
      purchases: map['purcahses'],
      sales: map['sales'],
      pendingOrders: ['pendingOrders'],
      postedFoods: map['postedFoods'],
    );
  }
}
