import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mealty/services/firestore_services.dart';
import 'package:mealty/data/model/user.dart';
import 'package:mealty/data/model/food_order.dart';

class OrderInfoWidget extends StatelessWidget {
  final FoodOrder order;
  final bool isSeller;
  final Function(String) onUpdateStatus;

  const OrderInfoWidget({
    super.key,
    required this.order,
    required this.isSeller,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    final onBackground = Theme.of(context).colorScheme.onBackground;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Status Pemesanan',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        FutureBuilder<User>(
          future: isSeller
              ? FirestoreService().getUser(order.buyerId)
              : FirestoreService().getUser(order.sellerId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final user = snapshot.data;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSeller ? 'Informasi Pembeli' : 'Informasi Penjual',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: onBackground,
                      ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  '${user?.username ?? 'user'} - ${user?.phoneNumber ?? '-'}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            );
          },
        ),
        if (isSeller && order.status == 'pending')
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
                        minimumSize: const Size(76.0, 38.0),
                        padding: EdgeInsets.zero,
                        backgroundColor: onPrimary,
                        side: BorderSide(color: primary),
                        elevation: 0.0,
                      ),
                      onPressed: () {
                        onUpdateStatus('cancelled');
                      },
                      child: Text(
                        'Tolak',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                              color: primary,
                            ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(104.0, 38.0),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        onUpdateStatus('confirmed');
                      },
                      child: Text(
                        'Konfirmasi',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
        if (!isSeller && order.status == 'confirmed')
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              children: [
                const SizedBox(height: 18.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(108.0, 38.0),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    onUpdateStatus('completed');
                  },
                  child: Text(
                    'Selesaikan',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                          color: onPrimary,
                        ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
