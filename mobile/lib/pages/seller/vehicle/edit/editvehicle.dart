import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:acruda/classes/pageargs/editvehicle.dart';
import 'package:acruda/pages/seller/vehicle/edit/widgets/editvehiclebasic.dart';
import 'package:acruda/pages/seller/vehicle/edit/widgets/editvehicledetails.dart';
import 'package:acruda/pages/seller/vehicle/edit/widgets/editvehicleimages.dart';
import 'package:acruda/pages/seller/vehicle/edit/widgets/editvehicleoverview.dart';
import 'package:acruda/pages/seller/vehicle/edit/widgets/editvehiclerates.dart';
import 'package:acruda/pages/seller/vehicle/edit/widgets/editvehiclerules.dart';
import 'package:acruda/pages/seller/vehicle/edit/widgets/editvehicleverification.dart';
import 'package:acruda/services/vehicle.dart';

enum EditSteps {
  overview,
  basic,
  details,
  images,
  rates,
  rules,
  verification,
  // standards
}

class EditVehiclePage extends HookWidget {
  final EditVehiclePageArgs args;
  const EditVehiclePage({super.key, required this.args});
  static const routeName = '/editevehicle';

  @override
  Widget build(BuildContext context) {
    final vehicle =
        useQuery(['${args.id}-vehicle'], () => listedVehicleDetails(args.id));
    final currentPage = useState<EditSteps>(EditSteps.overview);

    if (vehicle.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Vehicle"),
        ),
        body: const Center(
          child: Text("Loading"),
        ),
      );
    }

    Widget selectedPage = useMemoized(() {
      switch (currentPage.value) {
        case EditSteps.basic:
          return EditVehicleBasic(vehicle: vehicle.data!);
        case EditSteps.details:
          return EditVehicleDetails(vehicle: vehicle.data!);
        case EditSteps.images:
          return EditVehicleImages(vehicle: vehicle.data!);
        case EditSteps.rates:
          return EditVehicleRates(vehicle: vehicle.data!);
        case EditSteps.rules:
          return EditVehicleRules(vehicle: vehicle.data!);

        case EditSteps.verification:
          return EditVehicleVerification(vehicle: vehicle.data!);
        default:
          return EditVehicleOverview(
            currentPage: currentPage,
            vehicle: vehicle.data!,
          );
      }
    }, [currentPage.value]);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Vehicle"),
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            if (currentPage.value == EditSteps.overview) {
              Navigator.pop(context);
            } else {
              currentPage.value = EditSteps.overview;
            }
          },
        ),
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
