import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:mealty/provider/order_provider.dart';

class RatingDialog extends StatelessWidget {
  final String orderId;

  const RatingDialog({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color onBackground = Theme.of(context).colorScheme.onBackground;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 20.0,
                    color: onBackground,
                  ),
                  onPressed: () => context.pop(),
                ),
                const Spacer(),
                Text(
                  'Rating Penjual',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                Container(width: 48),
              ],
            ),
            const SizedBox(height: 20.0),
            Consumer<OrderProvider>(
              builder: (context, orderProvider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          highlightColor: Colors.transparent,
                          icon: Icon(
                            size: 34.0,
                            CupertinoIcons.star_fill,
                            color: index < orderProvider.selectedRating
                                ? Colors.orange[300]
                                : Colors.grey[300],
                          ),
                          onPressed: () {
                            orderProvider.setSelectedRating(index + 1);
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      orderProvider.ratingMessage,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13.0,
                        color: onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 40.0),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(108.0, 40.0),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () async {
                  final orderProvider = Provider.of<OrderProvider>(context, listen: false);
                  await orderProvider.submitOrderRating(orderId, orderProvider.selectedRating);
                  context.pop();
                },
                child: Text(
                  'Beri Rating',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                        color: onPrimary,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
