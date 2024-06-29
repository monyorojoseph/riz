import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mobile/classes/vehicle.dart';
import 'package:mobile/constants/vehicle.dart';
import 'package:mobile/pages/seller/vehicle/create.dart';
import 'package:mobile/services/vehicle.dart';

class CreateVehicleDetails extends HookWidget {
  final ValueNotifier<CreateSteps> currentPage;
  final ValueNotifier<Vehicle?> vehicle;
  final ValueNotifier<LandVehicle?> landVehicle;

  CreateVehicleDetails(
      {super.key,
      required this.currentPage,
      required this.vehicle,
      required this.landVehicle});

  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);
    return Column(
      children: <Widget>[
        FormBuilder(
          key: _formKey,
          child: Column(
            children: <Widget>[
              FormBuilderDropdown(
                name: 'type',
                decoration: const InputDecoration(labelText: 'Type'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                items: landVehicleTypes
                    .map(
                      (e) => DropdownMenuItem(
                        key: ValueKey(e['value']),
                        value: e['value'],
                        child: Text(e['label'] as String),
                      ),
                    )
                    .toList(),
                menuMaxHeight: 400,
              ),
              const SizedBox(height: 10),
              FormBuilderDropdown(
                name: 'engineType',
                decoration: const InputDecoration(labelText: 'Engine'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                items: engineTypes
                    .map(
                      (e) => DropdownMenuItem(
                        key: ValueKey(e['value']),
                        value: e['value'],
                        child: Text(e['label'] as String),
                      ),
                    )
                    .toList(),
                menuMaxHeight: 400,
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'engineSize',
                decoration: const InputDecoration(labelText: 'Engine Size'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              const SizedBox(height: 10),
              FormBuilderDropdown(
                name: 'fuelType',
                decoration: const InputDecoration(labelText: 'Fuel Type'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                items: fuelTypes
                    .map(
                      (e) => DropdownMenuItem(
                        key: ValueKey(e['value']),
                        value: e['value'],
                        child: Text(e['label'] as String),
                      ),
                    )
                    .toList(),
                menuMaxHeight: 400,
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'doors',
                decoration: const InputDecoration(labelText: 'No. of doors'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              FormBuilderDropdown(
                name: 'drivetrain',
                decoration: const InputDecoration(labelText: 'Drive Terrain'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                items: driveTerrainTypes
                    .map(
                      (e) => DropdownMenuItem(
                        key: ValueKey(e['value']),
                        value: e['value'],
                        child: Text(e['label'] as String),
                      ),
                    )
                    .toList(),
                menuMaxHeight: 400,
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'passengers',
                decoration:
                    const InputDecoration(labelText: 'No. of Passengers'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              const SizedBox(height: 10),
              FormBuilderDropdown(
                name: 'transmission',
                decoration: const InputDecoration(labelText: 'Transmission'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                items: transmissionTypes
                    .map(
                      (e) => DropdownMenuItem(
                        key: ValueKey(e['value']),
                        value: e['value'],
                        child: Text(e['label'] as String),
                      ),
                    )
                    .toList(),
                menuMaxHeight: 400,
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'load',
                decoration:
                    const InputDecoration(labelText: 'Load it can carry'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              const SizedBox(height: 30),
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
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        final formData = _formKey.currentState?.value;

                        if (formData != null) {
                          final data = {
                            'engineType': formData['engineType'].toString(),
                            'engineSize': formData['engineSize'].toString(),
                            'doors': formData['doors'].toString(),
                            'passengers': formData['passengers'].toString(),
                            'load': formData['load'].toString(),
                            'fuelType': formData['fuelType'].toString(),
                            'transmission': formData['transmission'].toString(),
                            'drivetrain': formData['drivetrain'].toString(),
                            'type': formData['type'].toString(),
                          };

                          debugPrint(data.toString());

                          try {
                            final vId = vehicle.value?.id;
                            if (vId != null) {
                              isLoading.value = true;
                              final newLandVehicle =
                                  await createLandVehicle(vId.toString(), data);
                              isLoading.value = false;
                              landVehicle.value = newLandVehicle;
                              currentPage.value = CreateSteps.images;
                            }
                          } catch (e) {
                            // Handle error
                            debugPrint('Failed to list vehicle: $e');
                            // Optionally show an error message to the user
                          }
                        }
                      }
                    },

                    child: Text(
                      isLoading.value ? 'Hold' : 'Next',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
