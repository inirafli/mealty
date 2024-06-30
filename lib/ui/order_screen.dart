import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/order_provider.dart';
import '../widgets/common/custom_snackbar.dart';
import '../widgets/foodorder/download_order_dialog.dart';
import '../widgets/foodorder/filter_order_dialog.dart';
import 'ordertab/buyer_orders_tab.dart';
import 'ordertab/seller_order_tab.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;

    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        if (orderProvider.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(
                contentText: orderProvider.errorMessage!,
                context: context,
              ),
            );
            orderProvider.clearErrorMessage();
          });
        }

        return DefaultTabController(
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
                        color: primary,
                      ),
                ),
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                actions: [
                  IconButton(
                    padding: const EdgeInsets.only(right: 8.0),
                    icon: Icon(MdiIcons.calendarFilterOutline,
                        color: primary, size: 24.0),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20.0)),
                        ),
                        builder: (context) => const FilterDialog(),
                      );
                    },
                  ),
                  IconButton(
                    padding: const EdgeInsets.only(right: 8.0),
                    icon: Icon(MdiIcons.fileDownloadOutline,
                        color: primary, size: 24.0),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20.0)),
                        ),
                        builder: (context) => const DownloadDialog(),
                      );
                    },
                  ),
                ],
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: BuyerOrdersTab(),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: SellerOrdersTab(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
