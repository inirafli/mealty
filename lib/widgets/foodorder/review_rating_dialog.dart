import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mealty/provider/order_provider.dart';

class ReviewRatingDialog extends StatefulWidget {
  final String orderId;
  final String foodId;

  const ReviewRatingDialog(
      {super.key, required this.orderId, required this.foodId});

  @override
  State<ReviewRatingDialog> createState() => _ReviewRatingDialogState();
}

class _ReviewRatingDialogState extends State<ReviewRatingDialog> {
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color onBackground = Theme.of(context).colorScheme.onBackground;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: onPrimary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ulas Pesanan',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 20.0,
                    color: onBackground,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
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
                                ? Colors.orange[600]
                                : Colors.grey[400],
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
                    const SizedBox(height: 24.0),
                    SizedBox(
                      height: 96.0,
                      child: TextField(
                        controller: _reviewController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: onPrimary,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: primary,
                              width: 0.75,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: primary,
                              width: 1.0,
                            ),
                          ),
                          hintText: 'Berikan Ulasan-mu disini',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: primary, fontWeight: FontWeight.w400),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 10.0),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    )
                  ],
                );
              },
            ),
            const SizedBox(height: 24.0),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40.0),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () async {
                  final orderProvider =
                      Provider.of<OrderProvider>(context, listen: false);
                  await orderProvider.submitOrderRatingAndReview(
                      widget.orderId,
                      widget.foodId,
                      orderProvider.selectedRating,
                      _reviewController.text);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Tambah Ulasan',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                        color: onPrimary,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
