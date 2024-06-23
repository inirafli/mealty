import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mealty/services/firestore_services.dart';
import 'package:mealty/data/model/cart.dart';
import 'package:mealty/utils/data_conversion.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../utils/fake_data_generator.dart';

class OrderItemWidget extends StatelessWidget {
  final CartItem item;
  final int totalPrice;

  const OrderItemWidget({
    super.key,
    required this.item,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onBackground = Theme.of(context).colorScheme.onBackground;

    return FutureBuilder<DocumentSnapshot?>(
      future: FirestoreService().getFoodPostById(item.foodId),
      builder: (context, snapshot) {
        final isLoading = !snapshot.hasData;
        final foodData = isLoading ? FakeDataGenerator.generatePlaceholderPost().toMap() : snapshot.data?.data() as Map<String, dynamic>?;

        if (foodData == null) {
          return const Center(child: Text('Food data not found'));
        }

        return Skeletonizer(
          enabled: isLoading,
          child: GestureDetector(
            onTap: () {
              context.push('/main/foodDetail', extra: item.foodId);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton.replace(
                  width: 64,
                  height: 64,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      foodData['image'],
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        foodData['name'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatPrice(foodData['price']),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: onBackground,
                            ),
                          ),
                          Text(
                            'x${item.quantity}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: onBackground,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 1.0),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          formatPrice(totalPrice),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}