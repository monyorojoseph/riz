import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:acruda/classes/vehicle.dart';
import 'package:acruda/pages/seller/vehicle/widgets/vehicleverificationform.dart';

class EditVehicleVerification extends HookWidget {
  final Vehicle vehicle;
  const EditVehicleVerification({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return VehicleVerficationForm(vehicle: vehicle);
  }
}
