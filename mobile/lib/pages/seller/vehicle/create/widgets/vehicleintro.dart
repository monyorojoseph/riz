import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:acruda/pages/seller/vehicle/create/create.dart';

class CreateVehicleIntro extends HookWidget {
  final ValueNotifier<CreateSteps> currentPage;
  const CreateVehicleIntro({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Row(
          children: <Widget>[
            Text(
              "How to Start Listing",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Talk About Your Vehicle",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Provide basic information about your vehicle, such as specifications, load capacity, and number of passengers.",
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Vehicle Images",
              textWidthBasis: TextWidthBasis.parent,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Add high-quality images of your vehicle to make it stand out.",
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Rental Rates",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Set your rental rates for potential renters.",
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Vehicle Verification",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Provide proof of vehicle ownership, road safety compliance, and maintenance history.",
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Rental Policy",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Set policies regarding who can rent your vehicle, such as requiring a valid driving license or identity verification.",
            ),
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
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
