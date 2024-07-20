import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class UserVerificationPage extends HookWidget {
  const UserVerificationPage({super.key});
  static const routeName = '/userVerification';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Verification"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            IdentityVerification(),
            const SizedBox(height: 20),
            DrivingLicenseVerification(),
          ],
        ),
      ),
    );
  }
}

class IdentityVerification extends HookWidget {
  IdentityVerification({super.key});
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Row(
          children: <Widget>[
            Icon(
              Icons.error,
              color: Colors.red,
            ),
            SizedBox(width: 10),
            Text(
              "Identity Verification",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          "Please provide a valid ID card or passport to verify that you are over 18 years old. This is required to ensure compliance with legal regulations.",
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () async {
            // Pick an image.
            final XFile? image =
                await picker.pickImage(source: ImageSource.gallery);
          },
          child: const Text(
            'Upload Document',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class DrivingLicenseVerification extends HookWidget {
  DrivingLicenseVerification({super.key});
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Row(
          children: <Widget>[
            Icon(
              Icons.error,
              color: Colors.red,
            ),
            SizedBox(width: 10),
            Text(
              "Driving License Verification",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          "Please provide your valid driving license to verify that you are legally permitted to drive. This ensures compliance with local driving regulations.",
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () async {
            // Pick an image.
            final XFile? image =
                await picker.pickImage(source: ImageSource.gallery);
          },
          child: const Text(
            'Upload Document',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
