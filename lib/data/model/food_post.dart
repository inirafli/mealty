import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mealty/data/model/user.dart';

import '../../utils/data_conversion.dart';

class FoodPost {
  final String id;
  final String category;
  final String description;
  final String image;
  final GeoPoint location;
  final String name;
  final int price;
  final int stock;
  final Timestamp publishedDate;
  final Timestamp saleTime;
  final String sellingType;
  final String userId;
  final User user;
  final double distance;
  final String formattedDistance;

  FoodPost({
    required this.id,
    required this.category,
    required this.description,
    required this.image,
    required this.location,
    required this.name,
    required this.price,
    required this.stock,
    required this.publishedDate,
    required this.saleTime,
    required this.sellingType,
    required this.userId,
    required this.user,
    required this.distance,
    required this.formattedDistance,
  });

  factory FoodPost.fromFirestore(
      DocumentSnapshot doc, User user, GeoPoint userLocation) {
    final data = doc.data() as Map<String, dynamic>;
    final double distance = calculateDistance(data['location'], userLocation);
    return FoodPost(
      id: doc.id,
      category: data['category'],
      description: data['description'],
      image: data['image'],
      location: data['location'],
      name: data['name'],
      price: data['price'],
      stock: data['stock'],
      publishedDate: data['publishedDate'],
      saleTime: data['saleTime'],
      sellingType: data['sellingType'],
      userId: data['userId'],
      user: user,
      distance: distance,
      formattedDistance: formatDistance(distance),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'stock': stock,
      'publishedDate': publishedDate,
      'saleTime': saleTime,
      'distance': distance,
      'category': category,
      'location': location,
      'formattedDistance': formattedDistance,
      'user': user.toMap(),
      'sellingType': sellingType,
      'userId': userId,
    };
  }

  factory FoodPost.fromMap(Map<String, dynamic> map) {
    return FoodPost(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      image: map['image'],
      stock: map['stock'],
      publishedDate: map['publishedDate'],
      saleTime: map['saleTime'],
      distance: map['distance'],
      category: map['category'],
      location: map['location'],
      formattedDistance: map['formattedDistance'],
      user: User.fromMap(map['user']),
      sellingType: map['sellingType'],
      userId: map['userId'],
    );
  }
}
