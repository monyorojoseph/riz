import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile/classes/vehicle.dart';
import 'package:mobile/pages/seller/vehicle/widgets/vehicleverificationform.dart';

class EditVehicleVerification extends HookWidget {
  final Vehicle vehicle;
  const EditVehicleVerification({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: VehicleVerficationForm(vehicle: vehicle),
      ),
    );
  }
}
