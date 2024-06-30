import 'package:mobile/classes/vehicle.dart';
import 'package:mobile/pages/seller/vehicle/create.dart';

class EditVehiclePageArgs {
  final String id;

  EditVehiclePageArgs(this.id);
}

class CreateVehiclePageArgs {
  final CreateSteps? page;
  final Vehicle? vehicle;

  CreateVehiclePageArgs({this.page = CreateSteps.intro, this.vehicle});
}
