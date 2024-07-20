import 'package:acruda/classes/vehicle.dart';
import 'package:acruda/pages/seller/vehicle/create/create.dart';

class EditVehiclePageArgs {
  final String id;

  EditVehiclePageArgs(this.id);
}

class CreateVehiclePageArgs {
  final CreateSteps? page;
  final Vehicle? vehicle;

  CreateVehiclePageArgs({this.page = CreateSteps.intro, this.vehicle});
}
