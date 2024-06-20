import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mealty/services/firestore_services.dart';
import 'package:mealty/data/model/food_order.dart';

class SellerOrdersTab extends StatelessWidget {
  const SellerOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return FutureBuilder<List<FoodOrder>>(
      future: user != null ? FirestoreService().getOrdersBySellerId(user.uid) : Future.value([]),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Belum ada pesanan.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }

        final orders = snapshot.data!;
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return ListTile(
              title: Text('Order ID: ${order.orderId}'),
              subtitle: Text('Total Harga: ${order.totalPrice}'),
              trailing: Text(order.status),
            );
          },
        );
      },
    );
  }
}
