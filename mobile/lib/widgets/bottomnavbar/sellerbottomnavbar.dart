import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:mobile/pages/account/account.dart';
import 'package:mobile/pages/history/history.dart';
import 'package:mobile/pages/home/home.dart';
import 'package:mobile/pages/loaders/switchpage.dart';
import 'package:mobile/pages/notifications/notifications.dart';
import 'package:mobile/pages/seller/calendar.dart';
import 'package:mobile/pages/seller/home.dart';
import 'package:mobile/pages/seller/menu.dart';
import 'package:mobile/pages/seller/notifications.dart';
import 'package:mobile/services/user.dart';

class SellerBottomNavbarItems extends HookWidget {
  const SellerBottomNavbarItems({super.key, required this.currentTab});
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
                  return const SellerHomePage();
                },
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
        },
      ),
      IconButton(
        tooltip: 'calendar',
        icon: const Icon(Icons.calendar_month_outlined),
        onPressed: () {
          if (currentTab != HistoryPage.routeName) {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (BuildContext context,
                    Animation<double> animation1,
                    Animation<double> animation2) {
                  return const SellerCalendarPage();
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
                  arguments: SwitchLoaderPageArgs('CLT'));
            }),
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
                  return const SellerNotificationPage();
                },
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
        },
      ),
      IconButton(
        tooltip: 'menu',
        icon: const Icon(Icons.menu),
        onPressed: () {
          if (currentTab != AccountPage.routeName) {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (BuildContext context,
                    Animation<double> animation1,
                    Animation<double> animation2) {
                  return const SellerMenuPage();
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
