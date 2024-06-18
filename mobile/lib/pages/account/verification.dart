import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class UserVerificationPage extends HookWidget {
  const UserVerificationPage({super.key});
  static const routeName = '/userVerification';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Verification"),
      ),
    );
  }
}
