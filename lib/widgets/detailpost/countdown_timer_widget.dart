import 'package:flutter/material.dart';
import 'dart:async';

import '../../data/model/food_post.dart';

class CountdownTimerWidget extends StatefulWidget {
  final FoodPost post;

  const CountdownTimerWidget({super.key, required this.post});

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
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
    Color secondary = Theme.of(context).colorScheme.secondary;
    Color onBackground = Theme.of(context).colorScheme.onBackground;

    return _remainingTime.inHours < 24
        ? Column(
          children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: secondary.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sisa Waktu Pemesanan',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: onBackground,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      _formatDuration(_remainingTime),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: onBackground,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16.0),
          ],
        )
        : const SizedBox.shrink();
  }
}
