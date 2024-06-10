import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../data/model/food_post.dart';
import '../widgets/detailpost/countdown_timer_widget.dart';
import '../widgets/detailpost/food_location_widget.dart';
import '../widgets/detailpost/name_description_category_widget.dart';
import '../widgets/detailpost/price_type_widgets.dart';
import '../widgets/detailpost/user_detail_widget.dart';

class FoodDetailScreen extends StatelessWidget {
  final FoodPost post;

  const FoodDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
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
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: onPrimary,
                                  ),
                        );
                },
              ),
              background: GestureDetector(
                onTap: () => context.push('/main/imageFullScreen', extra: post.image),
                child: Image.network(
                  post.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: IconButton(
                icon: Icon(
                  MdiIcons.arrowLeft,
                  color: onPrimary,
                  size: 24.0,
                ),
                onPressed: () {
                  context.pop();
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
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
                  PriceTypeWidget(post: post),
                  const SizedBox(height: 16.0),
                  CountdownTimerWidget(post: post),
                  NameDescriptionCategoryWidget(post: post),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              color: Colors.grey[200],
              padding: const EdgeInsets.only(
                  left: 24.0, right: 24.0, top: 20.0, bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserProfileWidget(user: post.user),
                  const SizedBox(height: 20.0),
                  FoodLocationWidget(
                    location: post.location,
                    formattedDistance: post.formattedDistance,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              'Tambahkan ke Keranjang',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
