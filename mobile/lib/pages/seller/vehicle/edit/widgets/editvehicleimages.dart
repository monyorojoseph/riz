import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:acruda/classes/vehicle.dart';
// import 'package:acruda/pages/seller/vehicle/widgets/vehicleimagesform.dart';
import 'package:acruda/services/url.dart';
import 'package:acruda/services/vehicle.dart';

class EditVehicleImages extends HookWidget {
  final Vehicle vehicle;
  const EditVehicleImages({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final images = useQuery(
        ['${vehicle.id}-vehicle-images'], () => vehicleImages(vehicle.id));

    return Column(
      mainAxisSize: MainAxisSize.min, // This makes the Column wrap its children
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          height: 200, // Set a specific height for the ListView
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: images.data
                    ?.map((e) => Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(12), // Rounded edges
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network('$baseUrl${e.image}'),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Handle delete action
                                  debugPrint('Delete image ${e.image}');
                                },
                              ),
                            ),
                          ],
                        ))
                    .toList() ??
                [],
          ),
        ),
        const SizedBox(height: 30),
        // VehicleImagesForm(vehicle: vehicle),
      ],
    );
  }
}
