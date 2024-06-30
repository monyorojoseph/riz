import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fquery/fquery.dart';
import 'package:mobile/classes/vehicle.dart';
import 'package:mobile/constants/pricing.dart';
import 'package:mobile/services/pricing.dart';

class EditVehicleRates extends HookWidget {
  final Vehicle vehicle;
  EditVehicleRates({super.key, required this.vehicle});
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);
    // final pricings =
    //     useQuery(['vehicle-pricings'], () => vehiclePricings(vehicle.id));

    return const Center(
      child: Text("ehll"),
    );
  }
}
