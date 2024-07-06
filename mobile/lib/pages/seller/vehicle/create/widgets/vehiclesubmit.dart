import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:mobile/classes/vehicle.dart';
import 'package:mobile/pages/seller/vehicle/create/create.dart';
import 'package:mobile/services/vehicle.dart';

class CreateVehicleLast extends HookWidget {
  final ValueNotifier<CreateSteps> currentPage;
  final ValueNotifier<Vehicle?> vehicle;

  const CreateVehicleLast(
      {super.key, required this.currentPage, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final vehicleId = vehicle.value?.id.toString();
    final vehicleOverview = useQuery(
      ['${vehicleId ?? ''}-overview-verification'],
      () => vehicleId != null
          ? vehicleVerificationOverview(vehicleId)
          : Future.value([]),
    );

    if (vehicleOverview.isLoading) {
      return const Center(
        child: Text("Loading"),
      );
    }

    if (vehicleOverview.isError) {
      return Center(
        child: Text(vehicleOverview.error.toString()),
      );
    }
    return Column(children: <Widget>[
      ...vehicleOverview.data
              ?.map((vov) => StageOverview(overview: vov))
              .toList() ??
          [],
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          MaterialButton(
            // minWidth: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 7.5),
            color: Colors.black,
            onPressed: () {
              currentPage.value = CreateSteps.verification;
            },
            child: const Text(
              'Back',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          MaterialButton(
            // minWidth: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 7.5),
            color: Colors.black,
            onPressed: () {},
            child: const Text(
              'Save',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ],
      ),
    ]);
  }
}

class StageOverview extends HookWidget {
  final VehicleVerificationOverview overview;
  const StageOverview({super.key, required this.overview});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: <Widget>[
          Icon(
            overview.passed ? Icons.check_circle : Icons.cancel,
            color: overview.passed ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Text(
            overview.message,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ))
        ],
      ),
    );
  }
}
