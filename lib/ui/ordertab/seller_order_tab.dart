import 'package:flutter/material.dart';
import 'package:mealty/widgets/common/alert_text.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../provider/order_provider.dart';
import '../../widgets/foodorder/order_filter_widget.dart';
import '../../widgets/foodorder/order_info_widget.dart';
import '../../widgets/foodorder/order_item_widget.dart';

class SellerOrdersTab extends StatelessWidget {
  const SellerOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        final orders = orderProvider.sellerOrders;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const OrderFilterWidget(),
            Expanded(
              child: Skeletonizer(
                enabled: orderProvider.isLoading,
                child: RefreshIndicator(
                  onRefresh: orderProvider.refreshOrders,
                  child: orders.isEmpty
                      ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 275,
                      child: const Center(
                        child: AlertText(
                          displayText: 'Belum ada Penjualan Makanan',
                        ),
                      ),
                    ),
                  )
                      : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
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
                              const SizedBox(height: 8.0),
                              OrderInfoWidget(
                                order: order,
                                isSeller: true,
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
            ),
          ],
        );
      },
    );
  }
}