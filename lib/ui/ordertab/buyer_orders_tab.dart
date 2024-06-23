import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../provider/order_provider.dart';
import '../../widgets/foodorder/order_filter_widget.dart';
import '../../widgets/foodorder/order_info_widget.dart';
import '../../widgets/foodorder/order_item_widget.dart';

class BuyerOrdersTab extends StatelessWidget {
  const BuyerOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        final orders = orderProvider.buyerOrders;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const OrderFilterWidget(),
            if (orders.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'Belum ada Pembelian Makanan',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              Expanded(
                child: Skeletonizer(
                  enabled: orderProvider.isLoading,
                  child: ListView.builder(
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
                                return OrderItemWidget(
                                  item: item,
                                  totalPrice: order.totalPrice,
                                );
                              }),
                              const SizedBox(height: 16.0),
                              OrderInfoWidget(
                                order: order,
                                isSeller: false,
                                onUpdateStatus: (newStatus) {
                                  orderProvider.updateOrderStatus(
                                      order.orderId, newStatus);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}