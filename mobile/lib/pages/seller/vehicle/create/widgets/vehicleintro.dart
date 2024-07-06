import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile/pages/seller/vehicle/create/create.dart';

class CreateVehicleIntro extends HookWidget {
  final ValueNotifier<CreateSteps> currentPage;
  const CreateVehicleIntro({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Row(
          children: <Widget>[
            Text(
              "How to start listing",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        const Column(
          children: <Widget>[
            Text(
              "Talk about your vehicle",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
                "Provide basic info like vehicle specs, load capacity, number of passengers")
          ],
        ),
        const SizedBox(height: 20),
        const Column(
          children: <Widget>[
            Text(
              "Vehicle images",
              textWidthBasis: TextWidthBasis.parent,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text("Add vehicle images to make it standout")
          ],
        ),
        const SizedBox(height: 20),
        const Column(
          children: <Widget>[
            Text(
              "Renting rates",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text("Set your renting rates")
          ],
        ),
        const SizedBox(height: 20),
        const Column(
          children: <Widget>[
            Text(
              "Finish up and publish",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
                "Make sure your identity is verified first, set who can rent your vehicle")
          ],
        ),
        const SizedBox(height: 50),
        MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 7.5),
          color: Colors.black,
          onPressed: () {
            currentPage.value = CreateSteps.basic;
          },
          child: const Text(
            'Start',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
