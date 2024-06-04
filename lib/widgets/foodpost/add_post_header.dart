import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddPostHeader extends StatelessWidget {
  final String title;

  const AddPostHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
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
