import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile/classes/pageargs/editvehicle.dart';
import 'package:mobile/classes/vehicle.dart';
import 'package:mobile/pages/seller/vehicle/create/widgets/vehiclebasic.dart';
import 'package:mobile/pages/seller/vehicle/create/widgets/vehicledetails.dart';
import 'package:mobile/pages/seller/vehicle/create/widgets/vehicleimages.dart';
import 'package:mobile/pages/seller/vehicle/create/widgets/vehicleintro.dart';
import 'package:mobile/pages/seller/vehicle/create/widgets/vehiclerates.dart';
import 'package:mobile/pages/seller/vehicle/create/widgets/vehiclerules.dart';
import 'package:mobile/pages/seller/vehicle/create/widgets/vehiclesubmit.dart';
import 'package:mobile/pages/seller/vehicle/create/widgets/vehicleverification.dart';
import 'package:mobile/pages/seller/vehicle/widgets/vehiclerulesform.dart';
import 'package:mobile/pages/seller/vehicle/widgets/vehicleverificationform.dart';

enum CreateSteps {
  intro,
  basic,
  details,
  images,
  rates,
  rules,
  verification,
  last
}

class CreateVehiclePage extends HookWidget {
  const CreateVehiclePage({super.key});
  static const routeName = '/createvehicle';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as CreateVehiclePageArgs;
    final currentPage = useState<CreateSteps>(args.page ?? CreateSteps.intro);
    final vehicle = useState<Vehicle?>(args.vehicle);
    final landVehicle = useState<LandVehicle?>(null);

    Widget selectedPage = useMemoized(() {
      switch (currentPage.value) {
        case CreateSteps.basic:
          return CreateVehicleBasic(
            currentPage: currentPage,
            vehicle: vehicle,
          );
        case CreateSteps.details:
          return CreateVehicleDetails(
              currentPage: currentPage,
              vehicle: vehicle,
              landVehicle: landVehicle);
        case CreateSteps.images:
          return CreateVehicleImages(
            currentPage: currentPage,
            vehicle: vehicle,
          );
        case CreateSteps.rates:
          return CreateVehicleRates(
            currentPage: currentPage,
            vehicle: vehicle,
          );
        case CreateSteps.rules:
          return VehicleRules(currentPage: currentPage, vehicle: vehicle);
        case CreateSteps.verification:
          return VehicleVerification(
              currentPage: currentPage, vehicle: vehicle);
        case CreateSteps.last:
          return CreateVehicleLast(
            currentPage: currentPage,
            vehicle: vehicle,
          );
        default:
          return CreateVehicleIntro(
            currentPage: currentPage,
          );
      }
    }, [currentPage.value]);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: selectedPage,
      ),
    );
  }
}
