import 'package:acruda/widgets/switc/switchcurrentscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:acruda/widgets/auth/logout.dart';

class SellerMenuPage extends HookWidget {
  const SellerMenuPage({super.key});
  static const routeName = '/sellermenu';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              Logout(),
              const SwitchCurrentScreen(screenName: "CSCRN"),
            ],
          )),
    );
  }
}
