import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mealty/provider/order_provider.dart';

class OrderFilterWidget extends StatelessWidget {
  const OrderFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    final onBackground = Theme.of(context).colorScheme.onBackground;
    final orderProvider = Provider.of<OrderProvider>(context);
    final filter = orderProvider.filter;

    final filters = {
      'all': 'Semua',
      'completed': 'Selesai',
      'pending': 'Pending',
      'confirmed': 'Terkonfirmasi',
      'cancelled': 'Tertolak',
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.entries.map((entry) {
          final isSelected = entry.key == filter;
          return GestureDetector(
            onTap: () => orderProvider.setFilter(entry.key),
            child: Container(
              margin: const EdgeInsets.only(top: 8.0, bottom: 12.0, right: 12.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: isSelected ? onBackground : onPrimary,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                entry.value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? onPrimary : onBackground,
                    ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
