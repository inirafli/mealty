import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mealty/services/firestore_services.dart';
import 'package:mealty/data/model/user.dart';
import 'package:mealty/data/model/food_order.dart';
import 'package:mealty/widgets/foodorder/rating_dialog_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../utils/data_conversion.dart';
import '../../utils/fake_data_generator.dart';

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
                  formatDate(order.orderDate),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16.0),
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
            final isLoading = !snapshot.hasData;
            final user = isLoading ? FakeDataGenerator.generateFakeUser() : snapshot.data;

            return Skeletonizer(
              enabled: isLoading,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
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
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Kode Reservasi',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: onBackground,
                        ),
                      ),
                      Text(
                        '#${order.orderId}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 8.0),
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
                        minimumSize: const Size(74.0, 37.0),
                        padding: EdgeInsets.zero,
                        backgroundColor: onPrimary,
                        side: BorderSide(color: primary),
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                        minimumSize: const Size(100.0, 37.0),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                    minimumSize: const Size(104.0, 37.0),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
        if (order.status == 'completed' && !isSeller)
          order.orderRating == 0
              ? Align(
            alignment: Alignment.bottomRight,
            child: Column(
              children: [
                const SizedBox(height: 18.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    backgroundColor: onPrimary,
                    minimumSize: const Size(156.0, 37.0),
                    padding: EdgeInsets.zero,
                    side: BorderSide(color: primary, width: 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          RatingDialog(orderId: order.orderId),
                    );
                  },
                  child: Text(
                    'Beri Rating Penjual',
                    style:
                    Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                      color: primary,
                    ),
                  ),
                ),
              ],
            ),
          )
              : Column(
            children: [
              const SizedBox(height: 18.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: List.generate(5, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Icon(
                      CupertinoIcons.star_fill,
                      size: 24.0,
                      color: index < order.orderRating
                          ? Colors.orange[300]
                          : Colors.grey[300],
                    ),
                  );
                }),
              ),
            ],
          ),
      ],
    );
  }
}