import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile/pages/account/account.dart';
import 'package:mobile/pages/history/history.dart';
import 'package:mobile/pages/home/home.dart';
import 'package:mobile/pages/notifications/notifications.dart';

class BottomNavbarItems extends HookWidget {
  const BottomNavbarItems({super.key, required this.currentTab});
  final String currentTab;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          tooltip: 'home',
          icon: const Icon(Icons.home),
          onPressed: () {
            if (currentTab != HomePage.routeName) {
              Navigator.pushNamed(context, HomePage.routeName);
            }
          },
        ),
        IconButton(
          tooltip: 'history',
          icon: const Icon(Icons.history),
          onPressed: () {
            if (currentTab != HistoryPage.routeName) {
              Navigator.pushNamed(context, HistoryPage.routeName);
            }
          },
        ),
        IconButton(
          tooltip: 'notifications',
          icon: const Icon(Icons.notifications),
          onPressed: () {
            if (currentTab != NotificationsPage.routeName) {
              Navigator.pushNamed(context, NotificationsPage.routeName);
            }
          },
        ),
        IconButton(
          tooltip: 'account',
          icon: const Icon(Icons.account_circle),
          onPressed: () {
            if (currentTab != AccountPage.routeName) {
              Navigator.pushNamed(context, AccountPage.routeName);
            }
          },
        ),
      ],
    );
  }
}
