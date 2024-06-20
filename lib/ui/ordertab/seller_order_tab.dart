import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mealty/data/model/user.dart';
import 'package:mealty/services/firestore_services.dart';
import 'package:provider/provider.dart';

import '../../provider/order_provider.dart';
import '../../utils/data_conversion.dart';
import '../../widgets/common/custom_loading_indicator.dart';

class SellerOrdersTab extends StatelessWidget {
  const SellerOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    final onBackground = Theme.of(context).colorScheme.onBackground;

    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        if (orderProvider.isLoading) {
          return Center(
              child: CustomProgressIndicator(
            color: primary,
            size: 24.0,
            strokeWidth: 2.0,
          ));
        }

        if (orderProvider.sellerOrders.isEmpty) {
          return Center(
            child: Text(
              'Belum ada Penjualan masuk.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }

        final orders = orderProvider.sellerOrders;
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
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          final foodData =
                              snapshot.data?.data() as Map<String, dynamic>?;
                          if (foodData == null) {
                            return const Center(
                                child: Text('Food data not found'));
                          }
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  foodData['image'],
                                  width: 64,
                                  height: 64,
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                            color: primary,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          formatPrice(foodData['price']),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: onBackground,
                                              ),
                                        ),
                                        Text(
                                          'x${item.quantity}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: onBackground,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 1.0),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        formatPrice(order.totalPrice),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tanggal Pemesanan',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: onBackground,
                                      ),
                                ),
                                Text(
                                  DateFormat.yMMMd()
                                      .format(order.orderDate.toDate()),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: primary,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            FutureBuilder<User>(
                              future: FirestoreService().getUser(order.buyerId),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                final buyer = snapshot.data;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Informasi Pembeli',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: onBackground,
                                          ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    Text(
                                      '${buyer?.username ?? 'user'} - ${buyer?.phoneNumber ?? '-'}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Status Pemesanan',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: onBackground,
                                  ),
                            ),
                            Text(
                              order.status == 'pending'
                                  ? 'Menunggu Konfirmasi'
                                  : order.status == 'confirmed'
                                      ? 'Terkonfirmasi'
                                      : order.status == 'cancelled'
                                          ? 'Tertolak'
                                          : 'Selesai',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: primary,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (order.status == 'pending')
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          children: [
                            const SizedBox(height: 18.0),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(76.0, 36.5),
                                    padding: EdgeInsets.zero,
                                    backgroundColor: onPrimary,
                                    side: BorderSide(color: primary),
                                    elevation: 0.0,
                                  ),
                                  onPressed: () {
                                    orderProvider.updateOrderStatus(
                                        order.orderId, 'cancelled');
                                  },
                                  child: Text(
                                    'Tolak',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.0,
                                          color: primary,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(104.0, 36.5),
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () {
                                    orderProvider.updateOrderStatus(
                                        order.orderId, 'confirmed');
                                  },
                                  child: Text(
                                    'Konfirmasi',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.0,
                                          color: onPrimary,
                                        ),
                                  ),
                                ),
                              ],
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
      },
    );
  }
}
