import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mealty/widgets/detailpost/category_stock_widget.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../provider/cart_provider.dart';
import '../provider/food_provider.dart';
import '../utils/cache_utils.dart';
import '../widgets/common/custom_snackbar.dart';
import '../widgets/detailpost/countdown_timer_widget.dart';
import '../widgets/detailpost/food_location_widget.dart';
import '../widgets/detailpost/name_description_widget.dart';
import '../widgets/detailpost/price_type_widgets.dart';
import '../widgets/detailpost/user_detail_widget.dart';
import '../widgets/detailpost/food_review_list.dart';

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
      Provider.of<FoodProvider>(context, listen: false)
          .fetchPostById(widget.postId);
    });
  }

  bool _isButtonEnabled(FoodProvider foodProvider) {
    final post = foodProvider.selectedPost;
    if (foodProvider.isDetailLoading || post == null) {
      return false;
    }
    final DateTime currentTime = DateTime.now();
    final DateTime saleEndTime = post.saleTime.toDate();
    if (post.stock <= 0 || saleEndTime.isBefore(currentTime)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      body: Consumer<FoodProvider>(
        builder: (context, foodProvider, child) {
          final post = foodProvider.selectedPost;
          final reviewCount = foodProvider.reviews.length;

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
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return constraints.biggest.height > 90
                            ? const SizedBox.shrink()
                            : Text(
                                post.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                      onTap: () => context.push('/main/imageFullScreen',
                          extra: post.image),
                      child: post.image.isNotEmpty
                          ? CachedNetworkImage(
                              cacheKey: 'image-cache-${post.id}',
                              imageUrl: post.image,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => SpinKitChasingDots(
                                  color: primary, size: 36.0),
                              cacheManager: AppCacheManager.instance,
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
                        const SizedBox(height: 14.0),
                        Skeletonizer(
                          enabled: foodProvider.isDetailLoading,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 20.0),
                            decoration: BoxDecoration(
                              color: onPrimary,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ulasan Pembeli',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.5, horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        MdiIcons.forumOutline,
                                        size: 16.0,
                                        color: onPrimary,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        '$reviewCount Ulasan',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: onPrimary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.0,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14.0),
                        Skeletonizer(
                            enabled: foodProvider.isDetailLoading,
                            child: const FoodReviewList()),
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
            padding:
                const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: primary.withOpacity(0.15),
                ),
                onPressed: _isButtonEnabled(foodProvider)
                    ? () {
                        Provider.of<CartProvider>(context, listen: false)
                            .addToCart(post, context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackBar(
                            contentText:
                                '${post.name} ditambahkan ke dalam Keranjang!',
                            context: context,
                          ),
                        );
                        context.pop();
                      }
                    : null,
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
