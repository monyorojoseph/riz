// create vehicle pricing
import 'dart:convert';

import 'package:acruda/classes/pricing.dart';
import 'package:acruda/services/url.dart';
import 'package:acruda/services/utils.dart';

Future<Pricing> createVehiclePricing(Map<String, dynamic> data) async {
  final response = await appService.genericPost(
      true, '$baseUrl/vehicle-pricing/create', data);

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return Pricing.fromJson(responseData);
  } else {
    throw Exception('Failed to create vehicle rate');
  }
}

Future<List<Pricing>> vehiclePricings(String id) async {
  final response =
      await appService.genericGet(true, '$baseUrl/vehicle-pricing/$id/all');

  if (response.statusCode == 200) {
    final List<dynamic> responseData = jsonDecode(response.body);
    // print(responseData);
    return responseData
        .map((e) => Pricing.fromJson(e as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Failed to get vehicle pricings.');
  }
}
