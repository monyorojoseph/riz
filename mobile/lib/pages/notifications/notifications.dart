import 'package:flutter/material.dart';
import 'package:acruda/widgets/bottomnavbar/clientbottomnavbaritems.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  static const routeName = '/notifications';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            bottom: const TabBar(tabs: <Widget>[
              Tab(
                text: "Notifications",
              ),
              Tab(
                text: "Messages",
              ),
            ]),
          ),
          body: const TabBarView(children: <Widget>[
            Center(
              child: Text("Notifcations"),
            ),
            Center(
              child: Text("Messages"),
            ),
          ])),
    );
  }
}
