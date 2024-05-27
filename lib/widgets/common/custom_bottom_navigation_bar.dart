import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: [
          _buildBottomNavigationBarItem(
              context, MdiIcons.homeOutline, MdiIcons.home, 'Beranda', 0, 26.0),
          _buildBottomNavigationBarItem(context, MdiIcons.cartOutline,
              MdiIcons.cart, 'Keranjang', 1, 23.0),
          _buildBottomNavigationBarItem(
              context,
              MdiIcons.textBoxMultipleOutline,
              MdiIcons.textBoxMultiple,
              'Riwayat',
              2,
              20.0),
          _buildBottomNavigationBarItem(context, MdiIcons.accountOutline,
              MdiIcons.account, 'Profil', 3, 26.0),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
    BuildContext context,
    IconData icon,
    IconData activeIcon,
    String label,
    int index,
    double iconSize,
  ) {
    final isSelected = selectedIndex == index;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return BottomNavigationBarItem(
      icon: Transform.translate(
        offset: isSelected ? const Offset(0, 0) : const Offset(0, -7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : primaryColor.withOpacity(0.6),
              size: iconSize,
            ),
            if (isSelected) ...[
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ],
        ),
      ),
      label: '',
      activeIcon: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            activeIcon,
            color: primaryColor,
            size: iconSize,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
