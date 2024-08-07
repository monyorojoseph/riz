import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:acruda/classes/pageargs/editvehicle.dart';
import 'package:acruda/classes/vehicle.dart';
import 'package:acruda/pages/seller/vehicle/create/widgets/vehiclebasic.dart';
import 'package:acruda/pages/seller/vehicle/create/widgets/vehicledetails.dart';
import 'package:acruda/pages/seller/vehicle/create/widgets/vehicleimages.dart';
import 'package:acruda/pages/seller/vehicle/create/widgets/vehicleintro.dart';
import 'package:acruda/pages/seller/vehicle/create/widgets/vehiclerates.dart';
import 'package:acruda/pages/seller/vehicle/create/widgets/vehiclerules.dart';
import 'package:acruda/pages/seller/vehicle/create/widgets/vehiclesubmit.dart';
import 'package:acruda/pages/seller/vehicle/create/widgets/vehicleverification.dart';

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
  final CreateVehiclePageArgs? args;
  const CreateVehiclePage({super.key, this.args});
  static const routeName = '/createvehicle';

  @override
  Widget build(BuildContext context) {
    final currentPage = useState<CreateSteps>(args?.page ?? CreateSteps.intro);
    final vehicle = useState<Vehicle?>(args?.vehicle);
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
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(25, 5, 25, 15),
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: selectedPage,
        ),
      ),
    );
  }
}
