import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:acruda/classes/vehicle.dart';
import 'package:acruda/pages/seller/vehicle/widgets/vehiclepricerateform.dart';

class EditVehicleRates extends HookWidget {
  final Vehicle vehicle;
  const EditVehicleRates({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return VehiclePriceRatesForm(vehicle: vehicle);
  }
}
