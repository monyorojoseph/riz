import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile/pages/auth/login.dart';
import 'package:mobile/services/auth.dart';
import 'package:mobile/utils/storage.dart';

class Logout extends StatelessWidget {
  Logout({super.key});
  final _storage = MyCustomSecureStorage();

  @override
  Widget build(BuildContext context) {
    return TextButton(
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
      child: const Row(
        children: <Widget>[
          Icon(
            Icons.logout_rounded,
            color: Colors.redAccent,
          ),
          SizedBox(width: 20),
          Text(
            "Logout",
            style: TextStyle(
                color: Colors.redAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
