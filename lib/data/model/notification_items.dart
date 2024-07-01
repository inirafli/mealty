import 'package:flutter/cupertino.dart';

class NotificationItem {
  final String category;
  final String title;
  final String description;
  final IconData icon;

  NotificationItem({
    required this.category,
    required this.title,
    required this.description,
    required this.icon,
  });
}
