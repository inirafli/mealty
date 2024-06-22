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
            Text(
              'Ingin mengunduh rangkuman Pembelian dan Penjualan yang sudah selesai?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: onBackground,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: onPrimary,
                    side: BorderSide(color: primary, width: 1.0),
                    minimumSize: const Size(140, 40),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Tidak, Kembali',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    minimumSize: const Size(140, 40),
                  ),
                  onPressed: () {
                    Provider.of<OrderProvider>(context, listen: false)
                        .downloadSummary(context);
                    context.pop();
                  },
                  child: Text(
                    'Iya, Unduh Rangkuman',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: onPrimary,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
