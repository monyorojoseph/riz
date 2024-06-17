import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile/pages/auth/login.dart';
import 'package:mobile/services/auth.dart';
import 'package:mobile/utils/storage.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  static const routeName = '/';
  final _storage = MyCustomSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black54,
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              String? access = await _storage.read(key: "accessToken");
              if (access != null) {
                Response response = await logoutUser(access);
                if (response.statusCode != 200) {
                  debugPrint("Failed to logout, on server");
                }
              }
              await _storage.delete(key: "accessToken");
              if (context.mounted) {
                Navigator.pushNamed(context, LoginPage.routeName);
              }
            },
            child: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
    );
  }
}
