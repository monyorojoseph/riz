import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile/widgets/bottomnavbar/sellerbottomnavbar.dart';

class SellerHomePage extends HookWidget {
  const SellerHomePage({super.key});
  static const routeName = '/seller';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: BottomAppBar(
          child: SellerBottomNavbarItems(
        currentTab: routeName,
      )),
    );
  }
}
