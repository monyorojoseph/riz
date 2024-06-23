import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile/pages/seller/vehicle/widgets/create/vehiclebasic.dart';
import 'package:mobile/pages/seller/vehicle/widgets/create/vehicleimages.dart';
import 'package:mobile/pages/seller/vehicle/widgets/create/vehicleintro.dart';
import 'package:mobile/pages/seller/vehicle/widgets/create/vehiclerates.dart';
import 'package:mobile/pages/seller/vehicle/widgets/create/vehiclesubmit.dart';

class CreateVehiclePage extends HookWidget {
  const CreateVehiclePage({super.key});
  static const routeName = '/createvehicle';

  @override
  Widget build(BuildContext context) {
    final currentPage = useState("INTRO");
    Widget selectedPage = useMemoized(() {
      switch (currentPage.value) {
        case "BASIC":
          return CreateVehicleBasic(
            currentPage: currentPage,
          );
        case "IMAGES":
          return CreateVehicleImages(
            currentPage: currentPage,
          );
        case "RATES":
          return CreateVehicleRates(
            currentPage: currentPage,
          );
        case "LAST":
          return CreateVehicleLast(
            currentPage: currentPage,
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
