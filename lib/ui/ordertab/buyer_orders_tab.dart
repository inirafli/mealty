import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mealty/services/firestore_services.dart';
import 'package:provider/provider.dart';

import '../../provider/order_provider.dart';
import '../../utils/data_conversion.dart';
import '../../widgets/common/custom_loading_indicator.dart';

class BuyerOrdersTab extends StatelessWidget {
  const BuyerOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color onBackground = Theme.of(context).colorScheme.onBackground;

    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        if (orderProvider.isLoading) {
          return Center(
              child: CustomProgressIndicator(
                color: primary,
                size: 24.0,
                strokeWidth: 2.0,
              )
          );
        }

        if (orderProvider.buyerOrders.isEmpty) {
          return Center(
            child: Text(
              'Belum ada Pembelian yang kamu lakukan.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }

        final orders = orderProvider.buyerOrders;
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6.0),
              decoration: BoxDecoration(
                color: onPrimary,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...order.foodItems.map((item) {
                      return FutureBuilder<DocumentSnapshot?>(
                        future: FirestoreService().getFoodPostById(item.foodId),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          final foodData = snapshot.data?.data() as Map<String, dynamic>?;
                          if (foodData == null) {
                            return Center(child: Text('Food data not found'));
                          }
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  foodData['image'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
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
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tanggal Pemesanan',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: onBackground,
                              ),
                            ),
                            Text(
                              DateFormat.yMMMd().format(order.orderDate.toDate()),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: primary,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Status Pemesanan',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: onBackground,
                              ),
                            ),
                            Text(
                              order.status,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}