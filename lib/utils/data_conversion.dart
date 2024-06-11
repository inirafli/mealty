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

double calculateDistance(GeoPoint location, GeoPoint userLocation) {
  const earthRadius = 6371000;

  double toRadians(double degree) => degree * (math.pi / 180);

  final lat1 = toRadians(userLocation.latitude);
  final lon1 = toRadians(userLocation.longitude);
  final lat2 = toRadians(location.latitude);
  final lon2 = toRadians(location.longitude);

  final dLat = lat2 - lat1;
  final dLon = lon2 - lon1;

  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1) * math.cos(lat2) * math.sin(dLon / 2) * math.sin(dLon / 2);
  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

  return earthRadius * c;
}

String formatDistance(double distance) {
  if (distance > 10000) {
    return '>10 km';
  } else if (distance >= 1000) {
    return '${(distance / 1000).toStringAsFixed(1)} km';
  } else {
    return '${distance.toStringAsFixed(0)} m';
  }
}
