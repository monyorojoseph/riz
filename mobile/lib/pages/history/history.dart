import 'package:flutter/material.dart';
import 'package:acruda/widgets/bottomnavbar/clientbottomnavbaritems.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});
  static const routeName = '/history';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Hello History"),
      bottomNavigationBar: BottomAppBar(
        child: ClientBottomNavbarItems(
          currentTab: routeName,
        ),
      ),
    );
  }
}
