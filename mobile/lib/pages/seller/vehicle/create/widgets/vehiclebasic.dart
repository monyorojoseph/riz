import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fquery/fquery.dart';
import 'package:mobile/classes/vehicle.dart';
import 'package:mobile/pages/seller/vehicle/create/create.dart';
import 'package:mobile/services/user.dart';
import 'package:mobile/services/vehicle.dart';

class CreateVehicleBasic extends HookWidget {
  final ValueNotifier<CreateSteps> currentPage;
  final ValueNotifier<Vehicle?> vehicle;
  CreateVehicleBasic(
      {super.key, required this.currentPage, required this.vehicle});
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);
    final user = useQuery(['userDetails'], getUserDetails);
    final vehicleBrands = useQuery(['vehicleBrands'], getVehicleBrands);
    final selectedBrand = useState<String?>(null);
    final vehicleModels = useQuery(
      ['vehicleModels', selectedBrand.value],
      () => selectedBrand.value != null
          ? getVehicleModels(selectedBrand.value!.toString())
          : Future.value([]),
      enabled: selectedBrand.value !=
          null, // Enable query only when brand is selected
    );

    if (vehicleBrands.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vehicleBrands.isError) {
      return const Center(child: Text('Error loading vehicle brands'));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  FormBuilderDropdown(
                    name: 'brand',
                    decoration: const InputDecoration(labelText: 'Brand'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    items: vehicleBrands.data
                            ?.map((e) => DropdownMenuItem(
                                  key: ValueKey(e.id),
                                  value: e.id,
                                  child: Text(e.name),
                                ))
                            .toList() ??
                        [],
                    onChanged: (value) {
                      selectedBrand.value = value.toString();
                    },
                    menuMaxHeight: 400,
                  ),
                  const SizedBox(height: 10),
                  if (selectedBrand.value != null && vehicleModels.isLoading)
                    const CircularProgressIndicator()
                  else if (selectedBrand.value != null && vehicleModels.isError)
                    const Text('Error loading vehicle models')
                  else
                    FormBuilderDropdown(
                      name: 'model',
                      decoration: const InputDecoration(labelText: 'Model'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      items: vehicleModels.data
                              ?.map((e) => DropdownMenuItem(
                                    key: ValueKey(e.id),
                                    value: e.id,
                                    child: Text(e.name),
                                  ))
                              .toList() ??
                          [],
                      menuMaxHeight: 400,
                    ),
                  const SizedBox(height: 10),
                  FormBuilderDateTimePicker(
                    name: "yom",
                    decoration:
                        const InputDecoration(labelText: "Year of Manufacture"),
                    inputType: InputType.date,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    lastDate: DateTime.now(),
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
                            "brand_id": formData['brand'].toString(),
                            "model_id": formData['model'].toString(),
                            "seller_id": user.data?.id,
                            "category": "LND",
                            "yom": (formData['yom'] as DateTime).toString(),
                          };

                          try {
                            isLoading.value = true;
                            final newVehicle = await listVehicle(data);
                            isLoading.value = false;
                            vehicle.value = newVehicle;
                            currentPage.value = CreateSteps.details;
                          } catch (e) {
                            // Handle error
                            debugPrint('Failed to list vehicle: $e');
                            // Optionally show an error message to the user
                          }
                        }
                      }
                    },
                    child: Text(
                      isLoading.value ? "Hold" : 'Next',
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
