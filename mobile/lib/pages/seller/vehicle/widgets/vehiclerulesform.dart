import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:mobile/classes/vehicle.dart';
import 'package:mobile/services/vehicle.dart';

class VehicleRentRulesForm extends HookWidget {
  final Vehicle vehicle;

  VehicleRentRulesForm({super.key, required this.vehicle});
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);
    final rentalpolicy = useQuery(['vehicle-rental-policy-${vehicle.id}'],
        () => vehicleRentalPolicy(vehicle.id));

    return Column(
      children: <Widget>[
        FormBuilder(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10),
                  const Text(
                    "Late Penalty",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  FormBuilderSwitch(
                    name: "latePenalty",
                    title: const Text("Apply a penalty for late returns"),
                    subtitle: const Text(
                        "A fee will be charged if the vehicle is not returned on time."),
                    initialValue: rentalpolicy.data?.latePenalty,
                    activeColor: Colors.black,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.black,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "User Verification",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  FormBuilderSwitch(
                    name: "verifiedUser",
                    title: const Text("Require user verification"),
                    subtitle: const Text(
                        "Only verified users are allowed to rent the vehicle."),
                    initialValue: rentalpolicy.data?.verifiedUser,
                    activeColor: Colors.black,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.black,
                  ),
                  FormBuilderSwitch(
                    name: "verifiedDl",
                    title: const Text("Require a valid driving license"),
                    subtitle: const Text(
                        "The renter must possess a valid driving license."),
                    initialValue: rentalpolicy.data?.verifiedDl,
                    activeColor: Colors.black,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.black,
                  ),
                  const SizedBox(height: 30),
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 7.5),
                    color: Colors.black,
                    onPressed: () async {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        final formData = _formKey.currentState?.value;
                        final id = rentalpolicy.data?.id;
                        if (formData != null) {
                          final data = {
                            'latePenalty': formData['latePenalty'],
                            'verifiedUser': formData['verifiedUser'],
                            'verifiedDl': formData['verifiedDl'],
                          };

                          try {
                            isLoading.value = true;
                            final newPolicy = await updateVehicleRentalPolicy(
                                id.toString(), data);
                            isLoading.value = false;
                          } catch (e) {
                            // Handle error
                            debugPrint(
                                'Failed to update vehicle rental policy: $e');
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
