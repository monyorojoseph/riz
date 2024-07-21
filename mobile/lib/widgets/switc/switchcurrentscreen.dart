import 'package:acruda/pages/loaders/switchpage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SwitchCurrentScreen extends StatelessWidget {
  final String screenName;
  const SwitchCurrentScreen({super.key, required this.screenName});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        GoRouter.of(context).go(SwitchLoaderPage.routeName,
            extra: SwitchLoaderPageArgs(screenName));
      },
      child: const Row(
        children: <Widget>[
          Icon(
            Icons.swap_horiz_outlined,
            color: Colors.green,
          ),
          SizedBox(width: 20),
          Text(
            "Switch",
            style: TextStyle(
                color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
