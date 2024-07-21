import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:acruda/classes/pageargs/editvehicle.dart';
import 'package:acruda/classes/utils.dart';
import 'package:acruda/classes/vehicle.dart';
import 'package:acruda/pages/seller/vehicle/create/create.dart';
import 'package:acruda/pages/seller/vehicle/edit/editvehicle.dart';
import 'package:acruda/services/url.dart';
import 'package:acruda/services/utils.dart';
import 'package:acruda/services/vehicle.dart';
import 'package:go_router/go_router.dart';

class EditVehicleOverview extends HookWidget {
  final ValueNotifier<EditSteps> currentPage;
  final Vehicle vehicle;

  const EditVehicleOverview(
      {super.key, required this.currentPage, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);
    final displayVehicle = useState<bool>(vehicle.display);
    final vehicleOverview = useQuery(['${vehicle.id}-overview-verification'],
        () => vehicleVerificationOverview(vehicle.id));

    if (vehicleOverview.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          "Vehicle details",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          "You can edit your vehicle details, select what you want to update",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 40),
        GestureDetector(
          onTap: () {
            currentPage.value = EditSteps.basic;
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 7),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Basic Info",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            final bool passed = vehicleOverview.data
                    ?.where((element) => element.stage == "details")
                    .first
                    .passed ??
                false;

            if (passed) {
              currentPage.value = EditSteps.details;
            } else {
              GoRouter.of(context).go(CreateVehiclePage.routeName,
                  extra: CreateVehiclePageArgs(
                      vehicle: vehicle, page: CreateSteps.details));
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 7),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Vehicle Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            final bool passed = vehicleOverview.data
                    ?.where((element) => element.stage == "images")
                    .first
                    .passed ??
                false;

            if (passed) {
              currentPage.value = EditSteps.images;
            } else {
              GoRouter.of(context).go(CreateVehiclePage.routeName,
                  extra: CreateVehiclePageArgs(
                      vehicle: vehicle, page: CreateSteps.images));
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 7),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Vehicle Images",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            currentPage.value = EditSteps.rates;
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 7),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Vehicle pricing ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            currentPage.value = EditSteps.rules;
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 7),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Vehicle rental policy",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            currentPage.value = EditSteps.verification;
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 7),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Vehicle verification",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
        Row(
          children: <Widget>[
            Switch(
              value: displayVehicle.value,
              onChanged: (value) async {
                displayVehicle.value = value;
                if (value) {
                  // display action
                  isLoading.value = true;
                  final response = await appService.genericGet(
                      true, '$baseUrl/vehicle/${vehicle.id}/enable-display');
                  isLoading.value = false;
                  if (response.statusCode == 200) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Your vehicle is visible to the public'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } else {
                    displayVehicle.value = !value;
                    if (context.mounted) {
                      final msg = ErrorMessage.fromJson(
                          jsonDecode(response.body) as Map<String, dynamic>);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Update failed: ${msg.detail} to enable display.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                } else {
                  // hide action
                  isLoading.value = true;
                  final data = {
                    "model_id": vehicle.model.id.toString(),
                    "brand_id": vehicle.brand.id.toString(),
                    "category": vehicle.category,
                    "display": value
                  };
                  final response = await appService.genericPut(
                      '$baseUrl/vehicle/${vehicle.id}/update', data);
                  isLoading.value = false;
                  if (response.statusCode == 200) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Your vehicle is hidden from the public'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } else {
                    displayVehicle.value = !value;
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Update failed: Your vehicle is still visible to public.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              activeColor: Colors.green,
            ),
            const SizedBox(width: 10),
            Text(
              displayVehicle.value ? "Hide" : "Display",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )
          ],
        )
      ],
    );
  }
}
