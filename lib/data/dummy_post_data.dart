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
        'userId': 'rapli',
        'location': const GeoPoint(-6.370, 106.8200),
        'image':
            'https://upload.wikimedia.org/wikipedia/id/0/0c/Goreng_pisang.jpg',
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
            'https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Nasi_Uduk_Betawi.jpg/330px-Nasi_Uduk_Betawi.jpg',
      },
      {
        'name': 'Es Teh Manis',
        'description': 'Minuman segar pelepas dahaga.',
        'category': 'drinks',
        'sellingType': 'commercial',
        'price': 3000,
        'saleTime': Timestamp.fromDate(DateTime.parse('2024-05-30 17:00:00')),
        'userId': 'user456',
        'location': const GeoPoint(-6.4038, 106.8310),
        'image':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a8/Es_teh_gelas_jumbo.jpg/330px-Es_teh_gelas_jumbo.jpg',
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
            'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Tapioca_Chips.jpg/330px-Tapioca_Chips.jpg',
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
            'https://akcdn.detik.net.id/visual/2023/11/09/ilustrasi-buat-jus-alpukat_169.jpeg?w=650&q=90',
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
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3e/Fruit_cocktail.JPG/330px-Fruit_cocktail.JPG',
      },
      {
        'name': 'Bakso Mang Ujang',
        'description':
            'Bakso daging sapi dengan kuah yang gurih dan lezat. Cocok untuk dinikmati saat cuaca dingin.',
        'category': 'staple',
        'sellingType': 'sharing',
        'price': 0,
        'saleTime': Timestamp.fromDate(DateTime.parse('2024-06-02 13:30:00')),
        'userId': 'user202',
        'location': const GeoPoint(-6.200, 106.845),
        'image':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Baso_Malang_Karapitan.JPG/330px-Baso_Malang_Karapitan.JPG',
      },
      {
        'name': 'Rujak Buah',
        'description':
            'Rujak buah segar dengan bumbu kacang yang pedas dan nikmat. Menyegarkan di siang hari.',
        'category': 'fruitsVeg',
        'sellingType': 'sharing',
        'price': 0,
        'saleTime': Timestamp.fromDate(DateTime.parse('2024-06-03 11:00:00')),
        'userId': 'user303',
        'location': const GeoPoint(-6.300, 106.850),
        'image':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Rujak_Buah_%28Indonesian_Fruit_Salad%29.JPG/300px-Rujak_Buah_%28Indonesian_Fruit_Salad%29.JPG',
      },
      {
        'name': 'Kopi Tubruk',
        'description': 'Kopi tubruk khas Indonesia dengan aroma yang kuat.',
        'category': 'drinks',
        'sellingType': 'sharing',
        'price': 0,
        'saleTime': Timestamp.fromDate(DateTime.parse('2024-06-01 09:00:00')),
        'userId': 'user404',
        'location': const GeoPoint(-6.301, 106.851),
        'image':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Menikmati_mendoan_di_musim_hujan.jpg/1920px-Menikmati_mendoan_di_musim_hujan.jpg',
      },
    ];
  }
}
