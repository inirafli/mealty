import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SubScreenHeader extends StatelessWidget {
  final String title;

  const SubScreenHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onPrimary,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 6.0, right: 6.0, top: 12.0, bottom: 6.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(MdiIcons.arrowLeft),
            iconSize: 20.0,
            color: Theme.of(context).colorScheme.onBackground,
            onPressed: () {
              context.pop();
            },
          ),
          const Spacer(),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Spacer(),
          Container(width: 48), // Placeholder for centering text
        ],
      ),
    );
  }
}
