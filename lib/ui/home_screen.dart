import 'package:flutter/material.dart';
import 'package:mealty/provider/food_provider.dart';
import 'package:mealty/utils/fake_data_generator.dart';
import 'package:mealty/widgets/common/alert_text.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../provider/notification_provider.dart';
import '../widgets/home/category_filter_dialog.dart';
import '../widgets/home/filter_button.dart';
import '../widgets/home/food_post_card.dart';
import '../widgets/home/home_app_bar.dart';
import '../widgets/home/sort_filter_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _hasInput = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_updateInputStatus);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notificationProvider =
          Provider.of<NotificationProvider>(context, listen: false);
      notificationProvider.fetchNotifications();
    });
  }

  void _updateInputStatus() {
    setState(() {
      _hasInput = _searchController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_updateInputStatus);
    _searchController.dispose();
    super.dispose();
  }

  void _showCategoryFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return const CategoryFilterDialog();
      },
    );
  }

  void _showSortFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return const SortFilterDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: HomeAppBar(
        searchController: _searchController,
        hasInput: _hasInput,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12.0),
          FilterButtons(
            onCategoryPressed: _showCategoryFilterDialog,
            onSortPressed: _showSortFilterDialog,
          ),
          const SizedBox(height: 12.0),
          Expanded(child:
              Consumer<FoodProvider>(builder: (context, foodProvider, child) {
            if (foodProvider.posts.isEmpty && !foodProvider.isLoading) {
              return const AlertText(
                  displayText:
                      'Belum ada Makanan atau Minuman yang tersedia');
            }

            return RefreshIndicator(
              onRefresh: foodProvider.refreshPosts,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                key: const PageStorageKey<String>('home_scroll_position'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 24.0,
                            child: Divider(
                              color: primary,
                              thickness: 1.25,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            'Katalog Mealty',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                              color: primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Divider(
                              color: primary,
                              thickness: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        const itemHeight = 320.0;
                        final itemWidth = (width - 20.0) / 2;
                        final childAspectRatio = itemWidth / itemHeight;

                        final posts = foodProvider.isLoading
                            ? FakeDataGenerator.generateListPosts()
                            : foodProvider.posts;

                        return Skeletonizer(
                          enabled: foodProvider.isLoading,
                          child: GridView.builder(
                            padding: const EdgeInsets.all(12.0),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 6.0,
                              childAspectRatio: childAspectRatio,
                            ),
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              final post = posts[index];
                              return PostCard(post: post);
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            );
              })),
        ],
      ),
    );
  }
}