import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:acruda/pages/auth/login.dart';
import 'package:acruda/services/auth.dart';
import 'package:acruda/utils/storage.dart';

class Logout extends StatelessWidget {
  Logout({super.key});
  final _storage = MyCustomSecureStorage();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  children: <Widget>[
                    const Text("Are you sure you want to logout ?"),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            String? access =
                                await _storage.read(key: "accessToken");
                            if (access != null) {
                              Response response = await logoutUser(access);
                              if (response.statusCode != 200) {
                                debugPrint("Failed to logout, on server");
                              }
                            }
                            await _storage.delete(key: "accessToken");
                            if (context.mounted) {
                              GoRouter.of(context).go(LoginPage.routeName);
                            }
                          },
                          child: const Text("Logout"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
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
