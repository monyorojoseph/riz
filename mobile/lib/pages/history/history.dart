import 'package:flutter/material.dart';
import 'package:mobile/widgets/bottomnavbaritems.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});
  static const routeName = '/history';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Hello History"),
      bottomNavigationBar: BottomAppBar(
          child: BottomNavbarItems(
        currentTab: routeName,
      )),
    );
  }
}
