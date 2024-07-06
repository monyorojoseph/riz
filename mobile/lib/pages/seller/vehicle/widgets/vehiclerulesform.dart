import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile/classes/vehicle.dart';

class VehicleRentRulesForm extends HookWidget {
  final Vehicle vehicle;

  VehicleRentRulesForm({super.key, required this.vehicle});
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);

    return Column(
      children: <Widget>[
        FormBuilder(
            key: _formKey,
            child: Column(children: <Widget>[
              FormBuilderSwitch(
                name: "deposit",
                title: const Text("Deposit"),
                initialValue: false,
              ),
              FormBuilderSwitch(
                name: "latePenalty",
                title: const Text("Late penalty"),
                initialValue: false,
              ),
              FormBuilderSwitch(
                name: "geographicLimit",
                title: const Text("Drive in same town"),
                initialValue: false,
              ),
              FormBuilderSwitch(
                name: "verifiedUser",
                title: const Text("User to be verified"),
                initialValue: false,
              ),
              FormBuilderSwitch(
                name: "verifiedDl",
                title: const Text("User must have a driving license"),
                initialValue: false,
              ),
              FormBuilderSwitch(
                name: "prohibitedUses",
                title: const Text("Prohibited uses cases"),
                initialValue: false,
              ),
              const SizedBox(height: 30),
              MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 7.5),
                color: Colors.black,
                onPressed: () async {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    final formData = _formKey.currentState?.value;
                    final vId = vehicle.id;
                    if (formData != null) {
                      // final data = {
                      //   'period': formData['period'].toString(),
                      //   'amount': formData['amount'].toString(),
                      //   'vehicle_id': vId.toString(),
                      // };

                      try {
                        isLoading.value = true;
                        // final pricing = await createVehiclePricing(data);
                        // isLoading.value = false;
                        // pricings.value.add(pricing);
                        // _formKey.currentState?.reset();
                        // currentPage.value = CreateSteps.last;
                      } catch (e) {
                        // Handle error
                        debugPrint('Failed to list vehicle: $e');
                        // Optionally show an error message to the user
                      }
                    }
                  }
                },
                child: Text(
                  isLoading.value ? 'Hold' : 'Save',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ]))
      ],
    );
  }
}
