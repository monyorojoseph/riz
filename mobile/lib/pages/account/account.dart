// import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:acruda/pages/account/editprofile.dart';
import 'package:acruda/pages/account/listvehicle.dart';
import 'package:acruda/pages/account/usersettings.dart';
import 'package:acruda/pages/account/verification.dart';
import 'package:acruda/services/user.dart';
import 'package:acruda/widgets/auth/logout.dart';
import 'package:acruda/widgets/bottomnavbar/clientbottomnavbaritems.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  static const routeName = '/account';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomAppBar(
        child: ClientBottomNavbarItems(
          currentTab: routeName,
        ),
      ),
      body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 100),
              UserDetails(),
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
                      "Verification",
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
  UserDetails({super.key});
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final user = useQuery(['userDetails'], getUserDetails);
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            const CircleAvatar(
              maxRadius: 60,
              backgroundImage: AssetImage('assets/defaults/user.jpg'),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () async {
                  // FilePickerResult? result =
                  //     await FilePicker.platform.pickFiles();

                  // Pick an image.
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                },
                child: const Icon(
                  Icons.image,
                  size: 30,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
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
