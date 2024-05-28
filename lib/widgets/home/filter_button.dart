import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FilterButtons extends StatelessWidget {
  final VoidCallback onCategoryPressed;
  final VoidCallback onSortPressed;

  const FilterButtons({
    super.key,
    required this.onCategoryPressed,
    required this.onSortPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildFilterButton(context, 'Kategori', onCategoryPressed),
        const SizedBox(width: 10.0),
        _buildFilterButton(context, 'Urutkan dari', onSortPressed),
      ],
    );
  }

  Widget _buildFilterButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.only(
            left: 16.0, right: 10.0, top: 8.0, bottom: 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(width: 4.0),
            Icon(
              MdiIcons.chevronDown,
              size: 20.0,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
