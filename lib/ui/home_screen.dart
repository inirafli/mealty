import 'package:flutter/material.dart';
import 'package:mealty/provider/food_provider.dart';
import 'package:mealty/widgets/common/custom_loading_indicator.dart';
import 'package:provider/provider.dart';
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
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      appBar: HomeAppBar(
        searchController: _searchController,
        hasInput: _hasInput,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 16.0, left: 16.0, right: 16.0, bottom: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilterButtons(
              onCategoryPressed: _showCategoryFilterDialog,
              onSortPressed: _showSortFilterDialog,
            ),
            const SizedBox(height: 16.0),
            Expanded(child:
                Consumer<FoodProvider>(builder: (context, foodProvider, child) {
              if (foodProvider.isLoading) {
                return Center(
                    child: CustomProgressIndicator(
                  color: primary,
                  size: 24.0,
                  strokeWidth: 2.0,
                ));
              }

              if (foodProvider.posts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/food_not_found.png',
                        fit: BoxFit.cover,
                        height: 144.0,
                      ),
                      Text(
                        'Belum ada Makanan atau Minuman\n yang tersedia.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: primary,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: foodProvider.refreshPosts,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  key: const PageStorageKey<String>('home_scroll_position'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Text(
                            'Eksplorasi Pilihan Mealty',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Divider(
                              color: primary,
                              thickness: 1.25,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 12.0,
                          childAspectRatio: 1.85 / 3,
                        ),
                        itemCount: foodProvider.posts.length,
                        itemBuilder: (context, index) {
                          final post = foodProvider.posts[index];
                          return PostCard(post: post);
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
      ),
    );
  }
}
