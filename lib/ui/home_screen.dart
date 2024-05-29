import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../common/dummy_post_data.dart';
import '../widgets/home/category_filter_dialog.dart';
import '../widgets/home/filter_button.dart';
import '../widgets/home/food_post_card.dart';
import '../widgets/home/sort_filter_dialog.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
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
    final dummyPosts = DummyPostData.getPosts();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(66.0),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40.0,
                  child: TextField(
                    controller: _searchController,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Mau cari makan apa hari ini?',
                      hintStyle:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                      prefixIcon: _hasInput
                          ? null
                          : Icon(
                              MdiIcons.storeSearchOutline,
                              size: 18.5,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      suffixIcon: _hasInput
                          ? IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 40,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.onPrimary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 2.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                height: 40.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: IconButton(
                  icon: Icon(
                    MdiIcons.hamburgerPlus,
                    size: 20.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    // Define the action for the hamburger button here
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilterButtons(
              onCategoryPressed: _showCategoryFilterDialog,
              onSortPressed: _showSortFilterDialog,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Text(
                          'Eksplorasi Pilihan Mealty',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Divider(
                            color: Theme.of(context).colorScheme.primary,
                            thickness: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 12.0,
                        childAspectRatio: 1.85 / 3,
                      ),
                      itemCount: dummyPosts.length,
                      itemBuilder: (context, index) {
                        final post = dummyPosts[index];
                        return PostCard(post: post);
                      },
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}