import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SellerNotificationPage extends HookWidget {
  const SellerNotificationPage({super.key});
  static const routeName = '/sellernotification';

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
        ]),
      ),
    );
  }
}
