import 'package:acruda/pages/account/account.dart';
import 'package:acruda/pages/history/history.dart';
import 'package:acruda/pages/home/home.dart';
import 'package:acruda/pages/notifications/notifications.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldClientNavBar extends StatelessWidget {
  const ScaffoldClientNavBar({required this.child, super.key});

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
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Account',
          ),
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location == HomePage.routeName) {
      return 0;
    }
    if (location == HistoryPage.routeName) {
      return 1;
    }
    if (location == NotificationsPage.routeName) {
      return 2;
    }
    if (location == AccountPage.routeName) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go(HomePage.routeName);
      case 1:
        GoRouter.of(context).go(HistoryPage.routeName);
      case 2:
        GoRouter.of(context).go(NotificationsPage.routeName);

      case 3:
        GoRouter.of(context).go(AccountPage.routeName);
    }
  }
}
