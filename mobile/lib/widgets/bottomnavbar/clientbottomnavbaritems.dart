import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:acruda/pages/account/account.dart';
import 'package:acruda/pages/history/history.dart';
import 'package:acruda/pages/home/home.dart';
import 'package:acruda/pages/loaders/switchpage.dart';
import 'package:acruda/pages/notifications/notifications.dart';
import 'package:acruda/services/user.dart';

class ClientBottomNavbarItems extends HookWidget {
  const ClientBottomNavbarItems({super.key, required this.currentTab});
  final String currentTab;

  @override
  Widget build(BuildContext context) {
    final usersetting = useQuery(['userSettingDetails'], getUserSettingDetails);

    List<Widget> children = [
      IconButton(
        tooltip: 'home',
        icon: const Icon(Icons.home_outlined),
        onPressed: () {
          if (currentTab != HomePage.routeName) {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (BuildContext context,
                    Animation<double> animation1,
                    Animation<double> animation2) {
                  return const HomePage();
                },
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
        },
      ),
      IconButton(
        tooltip: 'history',
        icon: const Icon(Icons.history_outlined),
        onPressed: () {
          if (currentTab != HistoryPage.routeName) {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (BuildContext context,
                    Animation<double> animation1,
                    Animation<double> animation2) {
                  return const HistoryPage();
                },
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
        },
      ),
    ];

    if (usersetting.data?.appPurpose == "SLR") {
      children.add(
        IconButton(
          tooltip: 'switch',
          icon: const Icon(Icons.swap_horiz_outlined, size: 40),
          onPressed: () {
            Navigator.pushNamed(context, SwitchLoaderPage.routeName,
                arguments: SwitchLoaderPageArgs('SSCRN'));
          },
        ),
      );
    }

    children.addAll([
      IconButton(
        tooltip: 'notifications',
        icon: const Icon(Icons.notifications_outlined),
        onPressed: () {
          if (currentTab != NotificationsPage.routeName) {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (BuildContext context,
                    Animation<double> animation1,
                    Animation<double> animation2) {
                  return const NotificationsPage();
                },
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
        },
      ),
      IconButton(
        tooltip: 'account',
        icon: const Icon(Icons.account_circle_outlined),
        onPressed: () {
          if (currentTab != AccountPage.routeName) {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (BuildContext context,
                    Animation<double> animation1,
                    Animation<double> animation2) {
                  return const AccountPage();
                },
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
        },
      ),
    ]);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }
}
