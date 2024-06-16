import 'package:flutter/material.dart';
import 'package:mobile/utils/storage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const <Widget>[
          Text("Home"),
        ],
      ),
    );
  }
}
