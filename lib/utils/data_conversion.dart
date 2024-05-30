import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

String formatPrice(int price) {
  final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');
  return formatter.format(price);
}

String formatSaleTime(Timestamp saleTime) {
  final now = DateTime.now();
  final saleDate = saleTime.toDate();
  final difference = saleDate.difference(now);

  if (difference.isNegative) {
    return 'Telah Selesai';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} jam lagi';
  } else {
    return '${difference.inDays} hari lagi';
  }
}

String calculateDistance(GeoPoint location) {
  // TODO: Replace this into realtime current location.
  const myLocation = GeoPoint(-6.4038, 106.8395);
  const earthRadius = 6371;

  double toRadians(double degree) => degree * (math.pi / 180);

  final lat1 = toRadians(myLocation.latitude);
  final lon1 = toRadians(myLocation.longitude);
  final lat2 = toRadians(location.latitude);
  final lon2 = toRadians(location.longitude);

  final dLat = lat2 - lat1;
  final dLon = lon2 - lon1;

  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1) * math.cos(lat2) * math.sin(dLon / 2) * math.sin(dLon / 2);
  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

  final distance = earthRadius * c;

  if (distance > 10) {
    return '>10 km';
  } else if (distance >= 1) {
    return '${distance.toStringAsFixed(1)} km';
  } else {
    return '${(distance * 1000).toStringAsFixed(0)} m';
  }
}
