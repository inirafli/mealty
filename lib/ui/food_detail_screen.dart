import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../data/model/food_post.dart';
import '../widgets/detailpost/countdown_timer_widget.dart';
import '../widgets/detailpost/name_description_category_widget.dart';
import '../widgets/detailpost/price_type_widgets.dart';
import '../widgets/detailpost/user_detail_widget.dart';

class FoodDetailScreen extends StatelessWidget {
  final FoodPost post;

  const FoodDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color secondary = Theme.of(context).colorScheme.secondary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color onBackground = Theme.of(context).colorScheme.onBackground;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.network(
              post.image,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 280,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height - 250,
              decoration: BoxDecoration(
                color: onPrimary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 16.0, top: 28.0, left: 24.0, right: 24.0),
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
                  Container(
                    width: double.infinity,
                    color: Colors.grey[200],
                    padding: const EdgeInsets.only(
                        bottom: 24.0, top: 16.0, left: 24.0, right: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UserProfileWidget(user: post.user),
                        // Add More Widgets
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 44,
            left: 16,
            child: CircleAvatar(
              backgroundColor: onPrimary.withOpacity(0.55),
              child: IconButton(
                icon: Icon(
                  MdiIcons.arrowLeft,
                  color: onBackground,
                ),
                onPressed: () {
                  context.pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
