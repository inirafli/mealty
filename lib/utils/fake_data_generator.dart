import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/model/cart.dart';
import '../data/model/food_order.dart';
import '../data/model/food_post.dart';
import '../data/model/user.dart';

class FakeDataGenerator {
  static User generateFakeUser() {
    return User(
      id: 'fakeUserId',
      email: 'fakeemail@example.com',
      phoneNumber: '1234567890',
      photoUrl: 'https://ui-avatars.com/api/?name=X',
      starRating: 4.5,
      countRating: 10,
      username: 'FakeUser',
      address: const GeoPoint(0, 0),
      completedFoodTypes: {
        'staple': 5,
        'drinks': 3,
        'snacks': 7,
        'fruitsVeg': 2,
        'total': 17,
      },
      purchases: [],
      sales: [],
      pendingOrders: [],
      postedFoods: [],
    );
  }

  static List<FoodOrder> generateFakeOrders() {
    return List.generate(3, (index) {
      return FoodOrder(
        orderId: 'order$index',
        buyerId: 'buyerId$index',
        sellerId: 'sellerId$index',
        foodItems: [
          CartItem(
            foodId: 'foodId$index',
            quantity: 2,
            price: 10000,
          ),
        ],
        status: 'pending',
        totalPrice: 10000,
        orderRating: 0,
        orderDate: Timestamp.now(),
        completionDate: null,
      );
    });
  }

  static FoodPost generatePlaceholderPost() {
    return FoodPost(
      id: 'placeholder',
      name: 'Loading...',
      description: 'Loading...',
      price: 30000,
      image: '',
      stock: 20,
      publishedDate: Timestamp.now(),
      saleTime: Timestamp.now(),
      distance: 12,
      category: 'staple',
      location: const GeoPoint(0, 0),
      formattedDistance: '0 km',
      user: User(
        id: 'placeholder',
        email: 'loading@example.com',
        phoneNumber: '0000000000',
        photoUrl: 'https://ui-avatars.com/api/?name=X',
        starRating: 0,
        countRating: 0,
        username: 'Loading...',
        address: const GeoPoint(0, 0),
        completedFoodTypes: {},
        purchases: [],
        sales: [],
        pendingOrders: [],
        postedFoods: [],
      ),
      sellingType: 'komersil',
      status: 'published',
      userId: 'xxxx',
    );
  }

  static List<FoodPost> generateListPosts() {
    return List.generate(6, (index) {
      return FoodPost(
        id: 'placeholder',
        name: 'Loading...',
        description: 'Loading...',
        price: 30000,
        image: '',
        stock: 20,
        publishedDate: Timestamp.now(),
        saleTime: Timestamp.now(),
        distance: 12,
        category: 'staple',
        location: const GeoPoint(0, 0),
        formattedDistance: '0 km',
        user: User(
          id: 'placeholder',
          email: 'loading@example.com',
          phoneNumber: '0000000000',
          photoUrl: 'https://ui-avatars.com/api/?name=X',
          starRating: 0,
          countRating: 0,
          username: 'Loading...',
          address: const GeoPoint(0, 0),
          completedFoodTypes: {},
          purchases: [],
          sales: [],
          pendingOrders: [],
          postedFoods: [],
        ),
        sellingType: 'komersil',
        status: 'published',
        userId: 'xxxx',
      );
    });
  }
}
