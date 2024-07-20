import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fquery/fquery.dart';
import 'package:acruda/classes/vehicle.dart';
import 'package:acruda/services/vehicle.dart';

class EditVehicleBasic extends HookWidget {
  final Vehicle vehicle;
  EditVehicleBasic({super.key, required this.vehicle});
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);
    final selectedBrand = useState<dynamic>(vehicle.brand.id);
    final vehicleBrands = useQuery(['vehicleBrands'], getVehicleBrands);
    final vehicleModels = useQuery(['vehicleModels', selectedBrand.value],
        () => getVehicleModels(selectedBrand.value.toString()));

    return Column(
      children: <Widget>[
        FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              if (vehicleBrands.isLoading)
                const CircularProgressIndicator()
              else if (vehicleBrands.isError)
                const Text('Error loading vehicle brands')
              else
                FormBuilderDropdown(
                  name: 'brand',
                  initialValue: selectedBrand.value,
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
              if (vehicleModels.isLoading)
                const CircularProgressIndicator()
              else if (vehicleModels.isError)
                const Text('Error loading vehicle models')
              else
                FormBuilderDropdown(
                  name: 'model',
                  initialValue: vehicle.model.id,
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
                initialValue: vehicle.yom,
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
                        "category": vehicle.category,
                        "yom": (formData['yom'] as DateTime).toString(),
                      };
                      try {
                        isLoading.value = true;
                        await updateVehicle(vehicle.id, data);
                        isLoading.value = false;
                      } catch (e) {
                        // debugPrint('Failed to update vehicle details: $e');
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Failed to update vehicle details: $e'),
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
    );
  }
}
