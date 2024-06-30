import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile/pages/seller/vehicle/editvehicle.dart';

class EditVehicleOverview extends HookWidget {
  final ValueNotifier<EditSteps> currentPage;
  const EditVehicleOverview({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      children: <Widget>[
        const Text(
          "Vehicle details",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          "You can edit your vehicle details, select what you want to update",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 40),
        GestureDetector(
          onTap: () {
            currentPage.value = EditSteps.basic;
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 7),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Basic Info",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            currentPage.value = EditSteps.details;
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 7),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Vehicle Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            currentPage.value = EditSteps.images;
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 7),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Vehicle Images",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            currentPage.value = EditSteps.rates;
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 7),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Vehicle pricing ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            currentPage.value = EditSteps.rules;
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 7),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Vehicles rules",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
