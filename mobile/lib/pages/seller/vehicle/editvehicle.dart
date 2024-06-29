import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile/classes/vehicle.dart';

enum EditSteps { overview, basic, details, images, rates }

class EditVehiclePage extends HookWidget {
  const EditVehiclePage({super.key});
  static const routeName = '/editevehicle';

  @override
  Widget build(BuildContext context) {
    // final currentPage = useState<EditSteps>(EditSteps.overview);
    // final vehicle = useState<Vehicle?>(null);
    // final landVehicle = useState<LandVehicle?>(null);

    // Widget selectedPage = useMemoized(() {
    //   switch (currentPage.value) {
    //     case EditSteps.basic:
    //       return EditVehicleBasic(currentPage: currentPage, vehicle: vehicle);
    //     case EditSteps.details:
    //       return EditVehicleDetails(
    //           currentPage: currentPage,
    //           vehicle: vehicle,
    //           landVehicle: landVehicle);
    //     case EditSteps.images:
    //       return EditVehicleImages(
    //           currentPage: currentPage, vehicle: vehicle);
    //     case EditSteps.rates:
    //       return EditVehicleRates(currentPage: currentPage, vehicle: vehicle);
    //     case EditSteps.last:
    //       return EditVehicleLast(
    //         currentPage: currentPage,
    //       );
    //     default:
    //       return EditVehicleIntro(
    //         currentPage: currentPage,
    //       );
    //   }
    // }, [currentPage.value]);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Vehicle"),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Text("Edit Vehicle"),
      ),
    );
  }
}
