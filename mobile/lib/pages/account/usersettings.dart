import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class UserSettingsPage extends HookWidget {
  const UserSettingsPage({super.key});
  static const routeName = '/userSetting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Settings"),
      ),
    );
  }
}
