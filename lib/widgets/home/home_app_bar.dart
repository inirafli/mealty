import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../provider/food_provider.dart';
import '../../provider/notification_provider.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final bool hasInput;

  const HomeAppBar({
    super.key,
    required this.searchController,
    required this.hasInput,
  });

  @override
  Widget build(BuildContext context) {
    final notificationProvider = context.watch<NotificationProvider>();
    final notificationCount = notificationProvider.notifications.length;

    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
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
                controller: searchController,
                onChanged: (value) {
                  Provider.of<FoodProvider>(context, listen: false)
                      .updateSearchKeyword(value);
                },
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Mau cari makan apa hari ini?',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  prefixIcon: hasInput
                      ? null
                      : Icon(
                          MdiIcons.storeSearchOutline,
                          size: 18.5,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  suffixIcon: hasInput
                      ? IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () {
                            searchController.clear();
                            Provider.of<FoodProvider>(context, listen: false)
                                .updateSearchKeyword('');
                          },
                        )
                      : null,
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 46,
                    minHeight: 40,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onPrimary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          Stack(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  MdiIcons.bellOutline,
                  size: 24.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  context.go('/main/notifications');
                },
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$notificationCount',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: onPrimary,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 6.0),
          SizedBox(
            width: 36.0,
            height: 40.0,
            child: IconButton(
              icon: Icon(
                MdiIcons.tagPlusOutline,
                size: 24.0,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                context.go('/main/manageFood', extra: {'isEdit': false});
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(66.0);
}
