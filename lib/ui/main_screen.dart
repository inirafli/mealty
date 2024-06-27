import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mealty/ui/profile_screen.dart';

import 'cart_screen.dart';
import 'home_screen.dart';
import 'order_screen.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      const CartScreen(),
      const OrderScreen(),
      const ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    Color primary = Theme.of(context).colorScheme.primary;

    final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 10.0,
        );

    return [
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.home),
        inactiveIcon: Icon(MdiIcons.homeOutline),
        title: ("Beranda"),
        textStyle: textStyle,
        activeColorPrimary: primary,
        inactiveColorPrimary: primary.withOpacity(0.6),
        iconSize: 30.0,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.cart),
        inactiveIcon: Icon(MdiIcons.cartOutline),
        title: ("Keranjang"),
        textStyle: textStyle,
        activeColorPrimary: primary,
        inactiveColorPrimary: primary.withOpacity(0.6),
        iconSize: 27.0,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.textBoxMultiple),
        inactiveIcon: Icon(MdiIcons.textBoxMultipleOutline),
        title: ("Riwayat"),
        textStyle: textStyle,
        activeColorPrimary: primary,
        inactiveColorPrimary: primary.withOpacity(0.6),
        iconSize: 24.0,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.account),
        inactiveIcon: Icon(MdiIcons.accountOutline),
        title: ("Profil"),
        textStyle: textStyle,
        activeColorPrimary: primary,
        inactiveColorPrimary: primary.withOpacity(0.6),
        iconSize: 30.0,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      // Default is Colors.white.
      handleAndroidBackButtonPress: true,
      // Default is true.
      resizeToAvoidBottomInset: true,
      // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true,
      // Default is true.
      hideNavigationBarWhenKeyboardShows: true,
      // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style4,
    );
  }
}
