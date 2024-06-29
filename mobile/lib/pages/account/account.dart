import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:mobile/pages/account/editprofile.dart';
import 'package:mobile/pages/account/listvehicle.dart';
import 'package:mobile/pages/account/usersettings.dart';
import 'package:mobile/pages/account/verification.dart';
import 'package:mobile/services/user.dart';
import 'package:mobile/widgets/auth/logout.dart';
import 'package:mobile/widgets/bottomnavbar/clientbottomnavbaritems.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  static const routeName = '/account';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomAppBar(
          child: ClientBottomNavbarItems(
        currentTab: routeName,
      )),
      body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 100),
              const UserDetails(),
              const SizedBox(height: 40),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, ProfilePage.routeName);
                },
                child: const Row(
                  children: <Widget>[
                    Icon(
                      Icons.account_circle_outlined,
                      color: Colors.black,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Profile",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, UserVerificationPage.routeName);
                },
                child: const Row(
                  children: <Widget>[
                    Icon(
                      Icons.verified_user_outlined,
                      color: Colors.black,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Identity Verification",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, UserSettingsPage.routeName);
                },
                child: const Row(
                  children: <Widget>[
                    Icon(
                      Icons.settings_outlined,
                      color: Colors.black,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "User Settings",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, UserListVehiclePage.routeName);
                },
                child: const Row(
                  children: <Widget>[
                    Icon(
                      Icons.car_rental_outlined,
                      color: Colors.black,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "List Vehicle",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Logout()
            ],
          )),
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
