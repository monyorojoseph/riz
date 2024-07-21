import 'package:acruda/pages/seller/calendar.dart';
import 'package:acruda/pages/seller/home.dart';
import 'package:acruda/pages/seller/menu.dart';
import 'package:acruda/pages/seller/notifications.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldSellerNavBar extends StatelessWidget {
  const ScaffoldSellerNavBar({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location == SellerHomePage.routeName) {
      return 0;
    }
    if (location == SellerCalendarPage.routeName) {
      return 1;
    }
    if (location == SellerNotificationPage.routeName) {
      return 2;
    }
    if (location == SellerMenuPage.routeName) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go(SellerHomePage.routeName);
      case 1:
        GoRouter.of(context).go(SellerCalendarPage.routeName);
      case 2:
        GoRouter.of(context).go(SellerNotificationPage.routeName);

      case 3:
        GoRouter.of(context).go(SellerMenuPage.routeName);
    }
  }
}
