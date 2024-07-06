import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fquery/fquery.dart';
import 'package:mobile/classes/pricing.dart';
import 'package:mobile/classes/vehicle.dart';
import 'package:mobile/constants/pricing.dart';
import 'package:mobile/pages/seller/vehicle/widgets/pricecard.dart';
import 'package:mobile/services/pricing.dart';

class VehiclePriceRatesForm extends HookWidget {
  final Vehicle vehicle;

  VehiclePriceRatesForm({super.key, required this.vehicle});
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);
    final usepricings =
        useQuery(['vehicle-pricings'], () => vehiclePricings(vehicle.id));
    final pricings = useState<List<Pricing>>([]);

    useEffect(() {
      if (usepricings.data?.isNotEmpty != null) {
        pricings.value = usepricings.data ?? [];
      }
    }, [usepricings]);

    if (usepricings.isLoading) {
      // use snack bar
    }

    if (usepricings.isError) {
      // use snack bar
    }

    // removing price rate

    return Column(
      children: <Widget>[
        ...pricings.value.map((price) => PriceCard(price: price)),
        const SizedBox(height: 30),
        if (pricings.value.length < 3)
          FormBuilder(
            key: _formKey,
            child: Column(
              children: <Widget>[
                FormBuilderDropdown(
                  name: 'period',
                  decoration: const InputDecoration(labelText: 'Rental Type'),
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
                      final vId = vehicle.id;
                      if (formData != null) {
                        final data = {
                          'period': formData['period'].toString(),
                          'amount': formData['amount'].toString(),
                          'vehicle_id': vId.toString(),
                        };

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
          )
        else
          const Column(
            children: <Widget>[
              Text("You have reached pricing limit"),
              SizedBox(height: 10),
              Text(
                  "You are only allowed to create 3 diffrent prices maximum, minimum one, that is for hourly, daily or monthly")
            ],
          ),
      ],
    );
  }
}
