import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:mobile/classes/vehicle.dart';
import 'package:mobile/pages/seller/vehicle/widgets/vehicleimagesform.dart';
import 'package:mobile/services/url.dart';
import 'package:mobile/services/vehicle.dart';

class EditVehicleImages extends HookWidget {
  final Vehicle vehicle;
  const EditVehicleImages({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final images = useQuery(
        ['${vehicle.id}-vehicle-images'], () => vehicleImages(vehicle.id));

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: images.data
                    ?.map((e) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Image.network('$baseUrl${e.image}'),
                        ))
                    .toList() ??
                [],
          ),
        ),
        const SizedBox(height: 30),
        VehicleImagesForm(vehicle: vehicle),
      ],
    );
  }
}
