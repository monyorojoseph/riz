import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:acruda/widgets/bottomnavbar/clientbottomnavbaritems.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Row(
          children: <Widget>[
            SizedBox(width: 20),
            Icon(
              Icons.location_on,
              color: Colors.black,
            ),
            SizedBox(width: 7.5),
            Text(
              "Nairobi, Ke",
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        child: ClientBottomNavbarItems(
          currentTab: routeName,
        ),
      ),
    );
  }
}
