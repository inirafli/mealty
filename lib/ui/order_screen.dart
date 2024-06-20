import 'package:flutter/material.dart';

import 'ordertab/buyer_orders_tab.dart';
import 'ordertab/seller_order_tab.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Pesanan',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Pembelian'),
              Tab(text: 'Penjualan'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            BuyerOrdersTab(),
            SellerOrdersTab(),
          ],
        ),
      ),
    );
  }
}