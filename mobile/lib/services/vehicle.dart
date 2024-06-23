import 'dart:convert';
import 'package:mobile/classes/vehicle.dart';
import 'package:mobile/services/utils.dart';

// vehicle brand
Future<List<VehicleBrand>> getVehicleBrands() async {
  final response = await genericGet(true, 'http://127.0.0.1:8000/brand/all');

  if (response.statusCode == 200) {
    final List<dynamic> responseData = jsonDecode(response.body);
    return responseData
        .map((e) => VehicleBrand.fromJson(e as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Failed to get vehicle brands.');
  }
}

// vehicle models
Future<List<VehicleModel>> getVehicleModels(String brandId) async {
  final response = await genericGet(
      true, 'http://127.0.0.1:8000/brand/models?brandId=$brandId');

  if (response.statusCode == 200) {
    final List<dynamic> responseData = jsonDecode(response.body);
    return responseData
        .map((e) => VehicleModel.fromJson(e as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Failed to get vehicle models.');
  }
}

// list vehicle
Future<Null> listVehicle(Map<String, dynamic> data) async {
  final response =
      await genericPost(true, 'http://127.0.0.1:8000/vehicle/create', data);

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    // return User.fromJson(responseData);
  } else {
    throw Exception('Failed to get user details.');
  }
}
// listed vehicle details
// my listed vehicles
// update listed vehicle
// deleted listed vehicle

