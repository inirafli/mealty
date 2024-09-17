import 'package:cloud_firestore/cloud_firestore.dart';

class FoodReview {
  final String userId;
  final String reviewMessage;
  final int rating;
  final Timestamp timeReview;

  FoodReview({
    required this.userId,
    required this.reviewMessage,
    required this.rating,
    required this.timeReview,
  });

  factory FoodReview.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FoodReview(
      userId: data['userId'],
      reviewMessage: data['reviewMessage'],
      rating: data['rating'],
      timeReview: data['timeReview'],
    );
  }
}
