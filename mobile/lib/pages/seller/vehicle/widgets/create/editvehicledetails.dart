import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fquery/fquery.dart';
import 'package:mobile/classes/vehicle.dart';
import 'package:mobile/constants/vehicle.dart';
import 'package:mobile/services/vehicle.dart';

class EditVehicleDetails extends HookWidget {
  final Vehicle vehicle;
  EditVehicleDetails({super.key, required this.vehicle});
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);
    final landvehicle = useQuery(['${vehicle.contentId}-landvehicle'],
        () => landVehicleDetails(vehicle.contentId!));
    if (landvehicle.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (landvehicle.isError) {
      return const Center(
        child: Text('Error loading vehicle details'),
      );
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            FormBuilder(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  FormBuilderDropdown(
                    name: 'type',
                    initialValue: landvehicle.data?.type,
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
                    initialValue: landvehicle.data?.engineType,
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
                    initialValue: landvehicle.data?.engineSize.toString(),
                    decoration: const InputDecoration(labelText: 'Engine Size'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(height: 10),
                  FormBuilderDropdown(
                    name: 'fuelType',
                    initialValue: landvehicle.data?.fuelType,
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
                    initialValue: landvehicle.data?.doors.toString(),
                    decoration:
                        const InputDecoration(labelText: 'No. of doors'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  FormBuilderDropdown(
                    name: 'drivetrain',
                    initialValue: landvehicle.data?.drivetrain,
                    decoration:
                        const InputDecoration(labelText: 'Drive Terrain'),
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
                    initialValue: landvehicle.data?.passengers.toString(),
                    decoration:
                        const InputDecoration(labelText: 'No. of Passengers'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(height: 10),
                  FormBuilderDropdown(
                    name: 'transmission',
                    initialValue: landvehicle.data?.transmission,
                    decoration:
                        const InputDecoration(labelText: 'Transmission'),
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
                    initialValue: landvehicle.data?.load.toString(),
                    decoration:
                        const InputDecoration(labelText: 'Load it can carry'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(height: 30),
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
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
                          try {
                            isLoading.value = true;
                            await updateLandVehicle(
                                landvehicle.data!.id.toString(), data);
                            isLoading.value = false;
                          } catch (e) {
                            // debugPrint('Failed to update vehicle details: $e');
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Failed to update land vehicle details: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                      }
                    },
                    child: Text(
                      isLoading.value ? "Saving" : 'Save',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
