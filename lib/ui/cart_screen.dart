import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';
import '../utils/data_conversion.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).loadCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color secondary = Theme.of(context).colorScheme.secondary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color onBackground = Theme.of(context).colorScheme.onBackground;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Keranjang',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: onPrimary,
              ),
        ),
      ),
      body: Stack(
        children: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              if (cartProvider.cartItems.isEmpty) {
                return Center(
                  child: Text(
                    'Keranjang Kosong',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 120.0, top: 16.0),
                itemCount: cartProvider.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartProvider.cartItems[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: onPrimary,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                          child: Image.network(
                            item.image,
                            width: 100,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: primary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 0.5),
                                Text(
                                  formatPrice(item.price),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: onBackground,
                                  ),
                                ),
                                const SizedBox(height: 2.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.delete_outline, size: 23.5, color: primary),
                                          onPressed: () {
                                            cartProvider.removeFromCart(item.id);
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(MdiIcons.minusCircleOutline, size: 23.0, color: primary),
                                          onPressed: () {
                                            if (item.quantity > 1) {
                                              cartProvider.updateCartItemQuantity(
                                                  item.id, item.quantity - 1);
                                            }
                                          },
                                        ),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          '${item.quantity}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: primary,
                                          ),
                                        ),
                                        const SizedBox(width: 4.0),
                                        IconButton(
                                          icon: Icon(MdiIcons.plusCircleOutline, size: 23.0, color: primary),
                                          onPressed: () {
                                            cartProvider.updateCartItemQuantity(
                                                item.id, item.quantity + 1);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              color: onPrimary,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Harga',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: onBackground,
                            ),
                      ),
                      Text(
                        formatPrice(Provider.of<CartProvider>(context)
                            .totalPrice
                            .toInt()),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(132.0, 44.0),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      // Implement the request submission functionality
                    },
                    child: Text(
                      'Buat Pesanan',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: onPrimary,
                          ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
