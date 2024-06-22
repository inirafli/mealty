import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:mealty/utils/data_conversion.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../data/model/food_post.dart';

class PostCard extends StatelessWidget {
  final FoodPost post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color secondary = Theme.of(context).colorScheme.secondary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color onBackrgound = Theme.of(context).colorScheme.onBackground;

    return GestureDetector(
      onTap: () {
        context.go('/main/foodDetail', extra: post.id);
      },
      child: Card(
        color: onPrimary,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Skeleton.replace(
                      width: double.infinity,
                      height: 153.0,
                      replacement: Container(
                        color: Colors.grey[300],
                        height: 153.0,
                        width: double.infinity,
                      ),
                      child: post.image.isNotEmpty
                          ? CachedNetworkImage(
                        cacheKey: 'image-cache-${post.image}',
                        imageUrl: post.image,
                        height: 153,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => SizedBox(
                          height: 153,
                          width: double.infinity,
                          child: Center(
                            child: Image.asset(
                              'assets/loading_primary.gif',
                              width: 44,
                              height: 44,
                            ),
                          ),
                        ),
                        cacheManager: CacheManager(Config(
                          'image-cache-${post.image}',
                          stalePeriod: const Duration(days: 1),
                        )),
                      )
                          : Container(
                        color: Colors.grey[300],
                        height: 153.0,
                        width: double.infinity,
                      ),
                    ),
                    if (post.sellingType == 'sharing')
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              color: secondary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 3.0, horizontal: 12.0),
                            child: Text(
                              'Berbagi',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.name,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: primary,
                                  height: 1.25,
                                  fontWeight: FontWeight.bold,
                                ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: secondary,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text(
                              formatSaleTime(post.saleTime),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: primary,
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: secondary,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text(
                              post.formattedDistance,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: primary,
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            post.user.username,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 13.0,
                                      color: onBackrgound,
                                    ),
                          ),
                          const SizedBox(width: 8.0),
                          Icon(
                            MdiIcons.circle,
                            size: 4.0,
                            color: onBackrgound,
                          ),
                          const SizedBox(width: 6.0),
                          const Icon(
                            CupertinoIcons.star_fill,
                            size: 14.0,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 2.0),
                          Text(
                            post.user.starRating.toString(),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 13.0,
                                      color: onBackrgound,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Text(
                formatPrice(post.price),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                      color: primary,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
