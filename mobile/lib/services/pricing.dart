// create vehicle pricing
import 'dart:convert';

import 'package:mobile/classes/pricing.dart';
import 'package:mobile/services/url.dart';
import 'package:mobile/services/utils.dart';

Future<Pricing> createVehiclePricing(Map<String, dynamic> data) async {
  final response =
      await genericPost(true, '$baseUrl/vehicle-pricing/create', data);

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return Pricing.fromJson(responseData);
  } else {
    throw Exception('Failed to get user details.');
  }
}
