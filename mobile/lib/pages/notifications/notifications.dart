import 'package:flutter/material.dart';
import 'package:mobile/widgets/bottomnavbaritems.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  static const routeName = '/notifications';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Hello notification"),
      bottomNavigationBar: BottomAppBar(
          child: BottomNavbarItems(
        currentTab: routeName,
      )),
    );
  }
}
