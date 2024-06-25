import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
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

  Food({
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
  });

  factory Food.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Food(
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
      'category': category,
      'location': location,
      'userId': userId,
      'sellingType': sellingType,
    };
  }

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      image: map['image'],
      stock: map['stock'],
      publishedDate: map['publishedDate'],
      saleTime: map['saleTime'],
      category: map['category'],
      location: map['location'],
      userId: map['userId'],
      sellingType: map['sellingType'],
    );
  }
}