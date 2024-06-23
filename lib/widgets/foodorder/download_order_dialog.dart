import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../provider/order_provider.dart';

class DownloadDialog extends StatelessWidget {
  const DownloadDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
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
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const Spacer(),
                Text(
                  'Unduh Rangkuman',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                Container(width: 48),
              ],
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Ingin mengunduh rangkuman Pembelian dan Penjualan yang sudah selesai?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: onBackground,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40.0),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  minimumSize: const Size(84.0, 40.0),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  Provider.of<OrderProvider>(context, listen: false)
                      .downloadSummary(context);
                  context.pop();
                },
                child: Text(
                  'Unduh',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
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
