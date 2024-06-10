import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../data/model/food_post.dart';
import '../utils/data_conversion.dart';
import '../widgets/detailpost/countdown_timer_widget.dart';
import '../widgets/detailpost/name_description_category_widget.dart';
import '../widgets/detailpost/price_type_widgets.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodPost post;

  const FoodDetailScreen({super.key, required this.post});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  late Timer _timer;
  Duration _remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemainingTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _updateRemainingTime();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    final saleDate = widget.post.saleTime.toDate();
    _remainingTime = saleDate.difference(now);
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

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
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PriceTypeWidget(post: post),
                  const SizedBox(height: 16.0),
                  CountdownTimerWidget(post: post),
                  NameDescriptionCategoryWidget(post: post),
                  // Add More Widgets
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
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}