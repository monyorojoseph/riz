import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:acruda/classes/vehicle.dart';
import 'package:image_picker/image_picker.dart';

class VehicleVerficationForm extends HookWidget {
  final Vehicle vehicle;

  const VehicleVerficationForm({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          "Vehicle Verification",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 50),
        ProveOfOwnershipDocs(),
        const SizedBox(height: 20),
        VehicleInspectionDocs(),
      ],
    );
  }
}

class ProveOfOwnershipDocs extends HookWidget {
  ProveOfOwnershipDocs({super.key});
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
              "Proof of Ownership",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text("Provide documents to prove ownership"),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () async {
            // Pick an image.
            final XFile? image =
                await picker.pickImage(source: ImageSource.gallery);
          },
          child: const Text(
            'Upload',
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

class VehicleInspectionDocs extends HookWidget {
  VehicleInspectionDocs({super.key});
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
              "Road Safety",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
            "Provide vehicle inspection documents to prove car is road worthy"),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () async {
            // Pick an image.
            final XFile? image =
                await picker.pickImage(source: ImageSource.gallery);
          },
          child: const Text(
            'Upload',
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
