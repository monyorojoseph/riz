import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile/classes/vehicle.dart';
import 'package:mobile/pages/seller/vehicle/widgets/vehiclerulesform.dart';

class EditVehicleRules extends HookWidget {
  final Vehicle vehicle;
  const EditVehicleRules({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return VehicleRentRulesForm(vehicle: vehicle);
  }
}
