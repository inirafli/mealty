import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mealty/widgets/common/alert_text.dart';
import 'package:provider/provider.dart';

import '../../provider/profile_provider.dart';
import '../../utils/cache_utils.dart';
import '../../utils/data_conversion.dart';
import '../../widgets/common/custom_loading_indicator.dart';
import '../../widgets/common/custom_snackbar.dart';
import '../../widgets/common/sub_screen_header.dart';
import '../../widgets/profile/profile_food_filter.dart';

class ProfileFoodScreen extends StatefulWidget {
  const ProfileFoodScreen({super.key});

  @override
  State<ProfileFoodScreen> createState() => _ProfileFoodScreenState();
}

class _ProfileFoodScreenState extends State<ProfileFoodScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false)
          .refreshUserFoodPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color onBackground = Theme.of(context).colorScheme.onBackground;
    Color secondary = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          backgroundColor: onPrimary,
        ),
      ),
      body: Stack(
        children: [
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SubScreenHeader(
              title: 'Daftar Unggahan Makanan',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 16.0, bottom: 8.0),
                  child: FoodFilterWidget(),
                ),
                Expanded(
                  child: Consumer<ProfileProvider>(
                    builder: (context, profileProvider, child) {
                      if (profileProvider.isLoading) {
                        return Center(
                          child: CustomProgressIndicator(
                            color: primary,
                            size: 24.0,
                            strokeWidth: 2.0,
                          ),
                        );
                      }

                      if (profileProvider.message != null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(
                              contentText: profileProvider.message!,
                              context: context,
                            ),
                          );
                          profileProvider.clearMessage();
                        });
                      }

                      if (profileProvider.filteredUserFoodPosts.isEmpty) {
                        return const AlertText(
                            displayText: 'Belum ada Makanan yang kamu Unggah');
                      }

                      return RefreshIndicator(
                        onRefresh: profileProvider.refreshUserFoodPosts,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, bottom: 24.0),
                          itemCount:
                              profileProvider.filteredUserFoodPosts.length,
                          itemBuilder: (context, index) {
                            final foodPost =
                                profileProvider.filteredUserFoodPosts[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              decoration: BoxDecoration(
                                color: onPrimary,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      context.push('/main/foodDetail',
                                          extra: foodPost.id);
                                    },
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                      child: CachedNetworkImage(
                                        cacheKey: 'image-cache-${foodPost.id}',
                                        imageUrl:  foodPost.image,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => SpinKitChasingDots(
                                            color: primary, size: 12.0),
                                        width: 120,
                                        height: 150,
                                        cacheManager: AppCacheManager.instance,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            foodPost.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0,
                                                  color: primary,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 0.5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                formatPrice(foodPost.price),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: onBackground,
                                                    ),
                                              ),
                                              const SizedBox(width: 4.0),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    MdiIcons.packageVariant,
                                                    color: primary,
                                                    size: 17.0,
                                                  ),
                                                  const SizedBox(width: 6.0),
                                                  Text(
                                                    foodPost.stock.toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          color: onBackground,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2.0),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                MdiIcons.clockTimeThreeOutline,
                                                color: primary,
                                                size: 17.0,
                                              ),
                                              const SizedBox(width: 6.0),
                                              Text(
                                                formatDate(foodPost.saleTime),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: onBackground,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0.0,
                                                  backgroundColor: secondary,
                                                  minimumSize:
                                                      const Size(42.0, 36.0),
                                                  padding: EdgeInsets.zero,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  if (foodPost.status ==
                                                      'published') {
                                                    profileProvider
                                                        .archiveFoodPost(
                                                            foodPost.id);
                                                  } else {
                                                    profileProvider
                                                        .unarchiveFoodPost(
                                                            foodPost.id);
                                                  }
                                                },
                                                child: Icon(
                                                  foodPost.status == 'published'
                                                      ? MdiIcons
                                                          .archiveArrowDownOutline
                                                      : MdiIcons
                                                          .archiveArrowUpOutline,
                                                  color: onBackground,
                                                  size: 18.0,
                                                ),
                                              ),
                                              const SizedBox(width: 8.0),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0.0,
                                                  backgroundColor: onBackground,
                                                  minimumSize:
                                                      const Size(42.0, 36.0),
                                                  padding: EdgeInsets.zero,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  context.push(
                                                    '/main/manageFood',
                                                    extra: {
                                                      'isEdit': true,
                                                      'foodData':
                                                          foodPost.toMap(),
                                                    },
                                                  );
                                                },
                                                child: Icon(
                                                  MdiIcons
                                                      .storefrontEditOutline,
                                                  color: secondary,
                                                  size: 18.0,
                                                ),
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
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
