import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile/classes/vehicle.dart';
import 'package:mobile/pages/seller/vehicle/create/create.dart';
import 'package:mobile/pages/seller/vehicle/widgets/vehiclepricerateform.dart';

class CreateVehicleRates extends HookWidget {
  final ValueNotifier<CreateSteps> currentPage;
  final ValueNotifier<Vehicle?> vehicle;

  const CreateVehicleRates(
      {super.key, required this.currentPage, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        VehiclePriceRatesForm(vehicle: vehicle.value!),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            MaterialButton(
              // minWidth: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 7.5),
              color: Colors.black,
              onPressed: () {
                currentPage.value = CreateSteps.images;
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
                currentPage.value = CreateSteps.rules;
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
