import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile/widgets/bottomnavbar/clientbottomnavbaritems.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppBar(),
      bottomNavigationBar: BottomAppBar(
          child: ClientBottomNavbarItems(
        currentTab: routeName,
      )),
    );
  }
}

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: const Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              LocationWidget(),
            ],
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size(200, kToolbarHeight);
}

// user Town
class LocationWidget extends HookWidget {
  const LocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: <Widget>[
        SizedBox(width: 20),
        Icon(
          Icons.location_on,
          color: Colors.white,
        ),
        SizedBox(width: 7.5),
        Text(
          "Nairobi, Ke",
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }
}
