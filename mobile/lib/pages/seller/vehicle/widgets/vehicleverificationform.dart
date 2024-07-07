import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile/classes/vehicle.dart';
import 'package:file_picker/file_picker.dart';

class VehicleVerficationForm extends HookWidget {
  final Vehicle vehicle;

  const VehicleVerficationForm({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        Text(
          "Vehicle Verification",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 50),
        ProveOfOwnershipDocs(),
        SizedBox(height: 20),
        VehicleInspectionDocs(),
      ],
    );
  }
}

class ProveOfOwnershipDocs extends HookWidget {
  const ProveOfOwnershipDocs({super.key});

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
            FilePickerResult? result = await FilePicker.platform.pickFiles();
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
  const VehicleInspectionDocs({super.key});

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
            FilePickerResult? result = await FilePicker.platform.pickFiles();
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
