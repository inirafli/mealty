import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/data_conversion.dart';

class FoodPost {
  final String id;
  final String category;
  final String description;
  final String image;
  final GeoPoint location;
  final String name;
  final int price;
  final Timestamp publishedDate;
  final Timestamp saleTime;
  final String sellingType;
  final String userId;
  final String username;
  final int starRating;
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
    required this.publishedDate,
    required this.saleTime,
    required this.sellingType,
    required this.userId,
    required this.username,
    required this.starRating,
    required this.distance,
    required this.formattedDistance,
  });

  factory FoodPost.fromFirestore(
      DocumentSnapshot doc, Map<String, dynamic> userData) {
    final data = doc.data() as Map<String, dynamic>;
    final double distance = calculateDistance(data['location']);
    return FoodPost(
      id: doc.id,
      category: data['category'],
      description: data['description'],
      image: data['image'],
      location: data['location'],
      name: data['name'],
      price: data['price'],
      publishedDate: data['publishedDate'],
      saleTime: data['saleTime'],
      sellingType: data['sellingType'],
      userId: data['userId'],
      username: userData['username'],
      starRating: userData['starRating'],
      distance: distance,
      formattedDistance: formatDistance(distance),
    );
  }
}
