import 'package:flutter/material.dart';
import 'package:mobile/widgets/bottomnavbar/clientbottomnavbaritems.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  static const routeName = '/notifications';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Hello notification"),
      bottomNavigationBar: BottomAppBar(
          child: ClientBottomNavbarItems(
        currentTab: routeName,
      )),
    );
  }
}
