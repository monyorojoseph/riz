import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile/classes/vehicle.dart';

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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
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
            SizedBox(height: 10),
            Text("Provide documents to prove ownership"),
            SizedBox(height: 5),
            Text(
              'Upload',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
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
            SizedBox(height: 10),
            Text(
                "Provide vehicle inspection documents to prove car is road worthy"),
            SizedBox(height: 5),
            Text(
              'Upload',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}



// ownershipDocuments
// inspectionDocuments