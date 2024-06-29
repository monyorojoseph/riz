import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mobile/classes/pricing.dart';
import 'package:mobile/classes/vehicle.dart';
import 'package:mobile/constants/pricing.dart';
import 'package:mobile/pages/seller/vehicle/create.dart';
import 'package:mobile/services/pricing.dart';

class CreateVehicleRates extends HookWidget {
  final ValueNotifier<CreateSteps> currentPage;
  final ValueNotifier<Vehicle?> vehicle;

  CreateVehicleRates(
      {super.key, required this.currentPage, required this.vehicle});
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);
    final pricings = useState<List<Pricing>>([]);

    return Column(
      children: <Widget>[
        ...pricings.value.map((price) => Text(price.amount.toString())),
        FormBuilder(
          key: _formKey,
          child: Column(
            children: <Widget>[
              FormBuilderDropdown(
                name: 'period',
                decoration: const InputDecoration(labelText: 'Period'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                items: pricingPeriodTypes
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
                name: 'amount',
                decoration: const InputDecoration(labelText: 'Amount'),
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
                    final vId = vehicle.value?.id;
                    if (vId != null) {
                      if (formData != null) {
                        final data = {
                          'period': formData['period'].toString(),
                          'amount': formData['amount'].toString(),
                          'vehicle_id': vId.toString(),
                        };

                        debugPrint(data.toString());

                        try {
                          isLoading.value = true;
                          final pricing = await createVehiclePricing(data);
                          isLoading.value = false;
                          pricings.value.add(pricing);
                          _formKey.currentState?.reset();
                          // currentPage.value = CreateSteps.last;
                        } catch (e) {
                          // Handle error
                          debugPrint('Failed to list vehicle: $e');
                          // Optionally show an error message to the user
                        }
                      }
                    }
                  }
                },
                child: Text(
                  isLoading.value ? 'Hold' : 'Add',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ],
          ),
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
                currentPage.value = CreateSteps.images;
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
              onPressed: () {
                currentPage.value = CreateSteps.last;
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
    );
  }
}
