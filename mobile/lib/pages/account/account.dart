// import 'package:file_picker/file_picker.dart';
import 'package:acruda/services/url.dart';
import 'package:acruda/services/utils.dart';
import 'package:acruda/utils/utils.dart';
import 'package:acruda/widgets/switc/switchcurrentscreen.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
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
import 'package:intl/intl.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  static const routeName = '/account';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              UserDetails(),
              const SizedBox(height: 40),
              TextButton(
                onPressed: () {
                  GoRouter.of(context).go(ProfilePage.routeName);
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
                  GoRouter.of(context).go(UserVerificationPage.routeName);
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
                  GoRouter.of(context).go(UserSettingsPage.routeName);
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
                  GoRouter.of(context).go(UserListVehiclePage.routeName);
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
              const SwitchCurrentScreen(screenName: "SSCRN"),
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
    final queryClient = useQueryClient();

    final user = useQuery(['userDetails'], getUserDetails);

    final userImage = user.data?.profilePicture != null
        ? NetworkImage('$baseUrl${user.data?.profilePicture}')
        : const AssetImage('assets/defaults/user.jpg');

    Future<void> pickAndUploadImage() async {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        String url = '$baseUrl/user/upload-pp';
        StreamedResponse streamResponse =
            await appService.uploadImage(url, image);
        if (streamResponse.statusCode == 200) {
          queryClient.invalidateQueries(['userDetails']);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload profile picture')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Picture is needed')),
        );
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            CircleAvatar(
              maxRadius: 35,
              backgroundImage: userImage as ImageProvider,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: pickAndUploadImage,
                child: const Icon(
                  Icons.image,
                  size: 30,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 30),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              user.data?.fullName ?? "",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "Joined ${user.data?.joinedOn != null ? formatDate(user.data!.joinedOn.toLocal()) : ""}",
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }
}
