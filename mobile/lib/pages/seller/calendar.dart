import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SellerCalendarPage extends HookWidget {
  const SellerCalendarPage({super.key});
  static const routeName = '/sellercalendar';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Your Reservations"),
      ),
    );
  }
}
