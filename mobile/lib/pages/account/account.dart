import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:http/http.dart';
import 'package:mobile/pages/account/editprofile.dart';
import 'package:mobile/pages/account/verification.dart';
import 'package:mobile/pages/auth/login.dart';
import 'package:mobile/services/auth.dart';
import 'package:mobile/services/user.dart';
import 'package:mobile/utils/storage.dart';
import 'package:mobile/widgets/bottomnavbaritems.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  static const routeName = '/account';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomAppBar(
          child: BottomNavbarItems(
        currentTab: routeName,
      )),
      body: Container(
        color: Colors.white,
        child: Expanded(
            child: Column(
          children: <Widget>[
            const SizedBox(height: 100),
            const UserDetails(),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, ProfilePage.routeName);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    "Edit profile",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, UserVerificationPage.routeName);
                },
                child: const Row(children: <Widget>[
                  Text(
                    "Verification",
                    style: TextStyle(color: Colors.black),
                  )
                ])),
            const SizedBox(height: 30),
            Logout()
          ],
        )),
      ),
    );
  }
}

class UserDetails extends HookWidget {
  const UserDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final user = useQuery(['userDetails'], getUserDetails);

    return Column(
      children: <Widget>[
        const CircleAvatar(
          maxRadius: 50,
          backgroundImage: AssetImage('assets/defaults/user.jpg'),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.verified_outlined),
            const SizedBox(width: 5),
            Text(
              user.data?.fullName ?? "",
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          user.data?.joinedOn.toString() ?? "",
          style: const TextStyle(fontSize: 12),
        )
      ],
    );
  }
}

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
            color: Colors.black45,
          ),
          SizedBox(width: 20),
          Text(
            "Logout",
            style: TextStyle(
                color: Colors.black45,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
