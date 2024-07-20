import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:acruda/classes/vehicle.dart';
import 'package:acruda/pages/seller/vehicle/create/create.dart';
// import 'package:acruda/pages/seller/vehicle/widgets/vehicleimagesform.dart';

// typedef Progress = Function(double percent);

class CreateVehicleImages extends HookWidget {
  final ValueNotifier<CreateSteps> currentPage;
  final ValueNotifier<Vehicle?> vehicle;

  const CreateVehicleImages(
      {super.key, required this.currentPage, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // VehicleImagesForm(vehicle: vehicle.value!),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            MaterialButton(
              // minWidth: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 7.5),
              color: Colors.black,
              onPressed: () {
                currentPage.value = CreateSteps.details;
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
              onPressed: () async {
                // if (pickedFiles.value?.isNotEmpty ?? false) {
                //   String? vId = vehicle.value?.id;
                //   if (vId?.isNotEmpty ?? false) {
                //     isLoading.value = true;
                //     String url = '$baseUrl/vehicle-images/$vId/create';
                //     StreamedResponse streamResponse =
                //         await appService.uploadImages(url, pickedFiles.value!);
                //     isLoading.value = false;

                //     if (streamResponse.statusCode == 200) {
                //       // print(streamResponse.stream.first.toString());
                //       currentPage.value = CreateSteps.rates;
                //     } else {
                //       throw Exception("Failed to upload images");
                //     }
                //   } else {
                //     debugPrint("No vehicle");
                //   }
                // } else {
                //   debugPrint("No Images");
                // }
                currentPage.value = CreateSteps.rates;
              },
              child: const Text(
                'Next',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
