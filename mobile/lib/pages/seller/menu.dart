import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:acruda/widgets/auth/logout.dart';
import 'package:acruda/widgets/bottomnavbar/sellerbottomnavbar.dart';

class SellerMenuPage extends HookWidget {
  const SellerMenuPage({super.key});
  static const routeName = '/sellermenu';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomAppBar(
        child: SellerBottomNavbarItems(
          currentTab: routeName,
        ),
      ),
      body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[const SizedBox(height: 100), Logout()],
          )),
    );
  }
}
