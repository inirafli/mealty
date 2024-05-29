import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:math' as math;

class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostCard({super.key, required this.post});

  String _formatPrice(int price) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');
    return formatter.format(price);
  }

  String _formatSaleTime(Timestamp saleTime) {
    final now = DateTime.now();
    final saleDate = saleTime.toDate();
    final difference = saleDate.difference(now);

    if (difference.isNegative) {
      return 'Waktu habis';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam lagi';
    } else {
      return '${difference.inDays} hari lagi';
    }
  }

  String _calculateDistance(GeoPoint location) {
    const myLocation = GeoPoint(-6.4038, 106.8395);
    const earthRadius = 6371; // in km

    double toRadians(double degree) => degree * (math.pi / 180);

    final lat1 = toRadians(myLocation.latitude);
    final lon1 = toRadians(myLocation.longitude);
    final lat2 = toRadians(location.latitude);
    final lon2 = toRadians(location.longitude);

    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
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

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color secondary = Theme.of(context).colorScheme.secondary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color onBackrgound = Theme.of(context).colorScheme.onBackground;

    return Card(
      color: onPrimary,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    cacheKey: 'image-cache-${post['image']}',
                    imageUrl: post['image'],
                    height: 153,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset(
                      'assets/loading_primary.gif',
                      width: 14.0,
                    ),
                    cacheManager: CacheManager(Config(
                      'image-cache-${post['image']}',
                      stalePeriod: const Duration(days: 1),
                    )),
                  ),
                  if (post['sellingType'] == 'sharing')
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: BoxDecoration(
                            color: secondary,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 12.0),
                          child: Text(
                            'Berbagi',
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['name'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: primary,
                            height: 1.25,
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: secondary,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            _formatSaleTime(post['saleTime']),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: primary,
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: secondary,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            _calculateDistance(post['location']),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: primary,
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          post['userId'],
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 13.0,
                                    color: onBackrgound,
                                  ),
                        ),
                        const SizedBox(width: 8.0),
                        Icon(
                          MdiIcons.circle,
                          size: 4.0,
                          color: onBackrgound,
                        ),
                        const SizedBox(width: 6.0),
                        Icon(
                          MdiIcons.star,
                          size: 16.0,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 2.0),
                        Text(
                          '4.0',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 13.0,
                                    color: onBackrgound,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Text(
              _formatPrice(post['price']),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                    color: primary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
