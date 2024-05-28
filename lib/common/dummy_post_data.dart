import 'package:cloud_firestore/cloud_firestore.dart';

class DummyPostData {
  static List<Map<String, dynamic>> getPosts() {
    return [
      {
        'name': 'Pisang Goreng Mas Ndo',
        'description':
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus vitae aliquam metus, ac consectetur tortor. Praesent ultrices turpis sed gravida porta. Duis rhoncus nibh vel lectus tempus vulputate. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nulla non varius dui. Duis aliquam suscipit ullamcorper. Proin vitae leo eget eros rutrum dictum gravida non eros.',
        'category': 'snacks',
        'sellingType': 'commercial',
        'price': 2500,
        'saleTime': Timestamp.fromDate(DateTime.parse('2024-05-30 15:14:30')),
        'userId': 'jKJSSrIl4sVzv26dDVT9T1TqYDC3',
        'location': const GeoPoint(6.373, 106.8344),
        'image':
            'https://cdn.pixabay.com/photo/2022/01/11/21/48/link-6931554_1280.png',
      },
      {
        'name': 'Nasi Uduk Bu Nani',
        'description': 'Nasi uduk dengan bumbu khas yang nikmat dan lezat.',
        'category': 'staple',
        'sellingType': 'commercial',
        'price': 10000,
        'saleTime': Timestamp.fromDate(DateTime.parse('2024-05-31 12:00:00')),
        'userId': 'user123',
        'location': const GeoPoint(6.371, 106.832),
        'image':
            'https://cdn.pixabay.com/photo/2022/01/11/21/48/link-6931554_1280.png',
      },
      {
        'name': 'Es Teh Manis',
        'description': 'Minuman segar pelepas dahaga.',
        'category': 'drinks',
        'sellingType': 'commercial',
        'price': 3000,
        'saleTime': Timestamp.fromDate(DateTime.parse('2024-05-30 17:00:00')),
        'userId': 'user456',
        'location': const GeoPoint(6.374, 106.835),
        'image':
            'https://cdn.pixabay.com/photo/2022/01/11/21/48/link-6931554_1280.png',
      },
      {
        'name': 'Keripik Singkong Pedas',
        'description': 'Keripik singkong dengan rasa pedas yang menggigit.',
        'category': 'snacks',
        'sellingType': 'commercial',
        'price': 5000,
        'saleTime': Timestamp.fromDate(DateTime.parse('2024-06-01 10:00:00')),
        'userId': 'user789',
        'location': const GeoPoint(6.375, 106.836),
        'image':
            'https://cdn.pixabay.com/photo/2022/01/11/21/48/link-6931554_1280.png',
      },
      {
        'name': 'Jus Alpukat',
        'description': 'Jus alpukat segar tanpa gula.',
        'category': 'drinks',
        'sellingType': 'commercial',
        'price': 8000,
        'saleTime': Timestamp.fromDate(DateTime.parse('2024-05-30 14:00:00')),
        'userId': 'user101',
        'location': const GeoPoint(6.376, 106.837),
        'image':
            'https://cdn.pixabay.com/photo/2022/01/11/21/48/link-6931554_1280.png',
      },
      {
        'name': 'Salad Buah',
        'description': 'Salad buah segar dengan berbagai macam buah-buahan.',
        'category': 'fruitsVeg',
        'sellingType': 'commercial',
        'price': 12000,
        'saleTime': Timestamp.fromDate(DateTime.parse('2024-05-29 15:00:00')),
        'userId': 'user102',
        'location': const GeoPoint(6.377, 106.838),
        'image':
            'https://cdn.pixabay.com/photo/2022/01/11/21/48/link-6931554_1280.png',
      },
    ];
  }
}
