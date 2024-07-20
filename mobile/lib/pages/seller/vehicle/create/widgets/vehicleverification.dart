import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:acruda/classes/vehicle.dart';
import 'package:acruda/pages/seller/vehicle/create/create.dart';
import 'package:acruda/pages/seller/vehicle/widgets/vehicleverificationform.dart';

class VehicleVerification extends HookWidget {
  final ValueNotifier<CreateSteps> currentPage;
  final ValueNotifier<Vehicle?> vehicle;

  const VehicleVerification(
      {super.key, required this.currentPage, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        VehicleVerficationForm(vehicle: vehicle.value!),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            MaterialButton(
              // minWidth: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 7.5),
              color: Colors.black,
              onPressed: () {
                currentPage.value = CreateSteps.rules;
              },
              child: const Text(
                'Back',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            MaterialButton(
              // minWidth: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 7.5),
              color: Colors.black,
              onPressed: () {
                currentPage.value = CreateSteps.last;
              },

              child: const Text(
                'Next',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
