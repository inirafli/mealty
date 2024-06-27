import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mealty/widgets/detailpost/category_stock_widget.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../provider/cart_provider.dart';
import '../provider/food_provider.dart';
import '../widgets/common/custom_snackbar.dart';
import '../widgets/detailpost/countdown_timer_widget.dart';
import '../widgets/detailpost/food_location_widget.dart';
import '../widgets/detailpost/name_description_widget.dart';
import '../widgets/detailpost/price_type_widgets.dart';
import '../widgets/detailpost/user_detail_widget.dart';

class FoodDetailScreen extends StatefulWidget {
  final String postId;

  const FoodDetailScreen({super.key, required this.postId});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FoodProvider>(context, listen: false).fetchPostById(widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      body: Consumer<FoodProvider>(
        builder: (context, foodProvider, child) {
          final post = foodProvider.selectedPost;

          if (post == null) {
            return const Center(
              child: Text('Tidak ada Makanan yang ditemukan.'),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverSkeletonizer(
                enabled: foodProvider.isDetailLoading,
                child: SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    title: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return constraints.biggest.height > 90
                            ? const SizedBox.shrink()
                            : Text(
                          post.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: onPrimary,
                          ),
                        );
                      },
                    ),
                    background: GestureDetector(
                      onTap: () => context.push('/main/imageFullScreen', extra: post.image),
                      child: post.image.isNotEmpty
                          ? Image.network(
                        post.image,
                        fit: BoxFit.cover,
                      )
                          : Container(color: Colors.grey[300]),
                    ),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: onPrimary,
                        size: 24.0,
                      ),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ),
                ),
              ),
              SliverSkeletonizer(
                enabled: foodProvider.isDetailLoading,
                child: SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: onPrimary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24.0),
                        topRight: Radius.circular(24.0),
                      ),
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Skeletonizer(
                          enabled: foodProvider.isDetailLoading,
                          child: PriceTypeWidget(post: post),
                        ),
                        const SizedBox(height: 16.0),
                        Skeletonizer(
                          enabled: foodProvider.isDetailLoading,
                          child: CountdownTimerWidget(post: post),
                        ),
                        Skeletonizer(
                          enabled: foodProvider.isDetailLoading,
                          child: NameDescWidget(post: post),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverSkeletonizer(
                enabled: foodProvider.isDetailLoading,
                child: SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey[200],
                    padding: const EdgeInsets.only(
                        left: 24.0, right: 24.0, top: 20.0, bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Skeletonizer(
                          enabled: foodProvider.isDetailLoading,
                          child: CategoryStockWidget(post: post),
                        ),
                        const SizedBox(height: 14.0),
                        Skeletonizer(
                          enabled: foodProvider.isDetailLoading,
                          child: UserProfileWidget(user: post.user),
                        ),
                        const SizedBox(height: 14.0),
                        Skeletonizer(
                          enabled: foodProvider.isDetailLoading,
                          child: FoodLocationWidget(
                            location: post.location,
                            formattedDistance: post.formattedDistance,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer<FoodProvider>(
        builder: (context, foodProvider, child) {
          final post = foodProvider.selectedPost;
          if (post == null) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<CartProvider>(context, listen: false).addToCart(post, context);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    CustomSnackBar(
                      contentText: '${post.name} ditambahkan ke dalam Keranjang!',
                      context: context,
                    ),
                  );

                  context.pop();
                },
                child: Text(
                  'Tambahkan ke Keranjang',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}