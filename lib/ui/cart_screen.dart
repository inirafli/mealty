import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';
import '../services/firestore_services.dart';
import '../utils/data_conversion.dart';
import '../widgets/common/custom_loading_indicator.dart';

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
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color onBackground = Theme.of(context).colorScheme.onBackground;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(54.0),
        child: AppBar(
          title: Text(
            'Keranjang',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          backgroundColor: onPrimary,
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
                padding: const EdgeInsets.only(bottom: 120.0, top: 16.0, left: 4.0, right: 4.0),
                itemCount: cartProvider.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartProvider.cartItems[index];
                  return FutureBuilder<DocumentSnapshot?>(
                    future: FirestoreService().getFoodPostById(item.foodId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: CustomProgressIndicator(
                              color: primary,
                              size: 24.0,
                              strokeWidth: 2.0,
                            ));
                      }
                      final foodData = snapshot.data?.data() as Map<String, dynamic>?;
                      if (foodData == null) {
                        return const Center(
                          child: Text('Tidak ada Makanan yang ditemukan.'),
                        );
                      }
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: onPrimary,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.push('/main/foodDetail', extra: item.foodId);
                              },
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                child: Image.network(
                                  foodData['image'],
                                  width: 100,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
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
                                      foodData['name'],
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: primary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 0.5),
                                    Text(
                                      formatPrice(foodData['price']),
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
                                                cartProvider.removeFromCart(item.foodId);
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(MdiIcons.minusCircleOutline, size: 23.0, color: primary),
                                              onPressed: () {
                                                if (item.quantity > 1) {
                                                  cartProvider.updateCartItemQuantity(
                                                      item.foodId, item.quantity - 1, foodData['stock'], context);
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
                                                    item.foodId, item.quantity + 1, foodData['stock'], context);
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
              );
            },
          ),
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Visibility(
                visible: cartProvider.cartItems.isNotEmpty,
                child: Positioned(
                  bottom: 16,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: onPrimary,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
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
                              formatPrice(cartProvider.totalPrice.toInt()),
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
                          onPressed: cartProvider.isLoading
                              ? null
                              : () {
                            cartProvider.placeOrder(context);
                          },
                          child: cartProvider.isLoading
                              ? CustomProgressIndicator(
                            color: onPrimary,
                            size: 18.0,
                            strokeWidth: 2.0,
                          )
                              : Text(
                            'Buat Pesanan',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}