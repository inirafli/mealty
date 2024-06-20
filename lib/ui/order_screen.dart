import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/order_provider.dart';
import 'ordertab/buyer_orders_tab.dart';
import 'ordertab/seller_order_tab.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OrderProvider(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(104.0),
            child: AppBar(
              title: Text(
                'Pesanan',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              bottom: TabBar(
                labelColor: Theme.of(context).colorScheme.primary,
                labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                tabs: const [
                  Tab(text: 'Pembelian'),
                  Tab(text: 'Penjualan'),
                ],
              ),
            ),
          ),
          body: const TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: BuyerOrdersTab(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: SellerOrdersTab(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}