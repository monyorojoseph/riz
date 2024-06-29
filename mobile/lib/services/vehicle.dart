import 'dart:convert';
import 'package:mobile/classes/vehicle.dart';
import 'package:mobile/services/url.dart';
import 'package:mobile/services/utils.dart';
import 'package:image_picker/image_picker.dart';

// vehicle brand
Future<List<VehicleBrand>> getVehicleBrands() async {
  final response = await genericGet(true, '$baseUrl/brand/all');

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
  final response =
      await genericGet(true, '$baseUrl/brand/models?brandId=$brandId');

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
Future<Vehicle> listVehicle(Map<String, dynamic> data) async {
  final response = await genericPost(true, '$baseUrl/vehicle/create', data);

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return Vehicle.fromJson(responseData);
  } else {
    throw Exception('Failed to get user details.');
  }
}

// create land vehicle

Future<LandVehicle> createLandVehicle(
    String vehicleId, Map<String, dynamic> data) async {
  final response =
      await genericPost(true, '$baseUrl/land-vehicle/$vehicleId/create', data);

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return LandVehicle.fromJson(responseData);
  } else {
    throw Exception('Failed to get user details.');
  }
}

// listed vehicle details
// my listed vehicles
Future<List<Vehicle>> myListedtVehicleModels() async {
  final response = await genericGet(true, '$baseUrl/user/vehicles');

  if (response.statusCode == 200) {
    final List<dynamic> responseData = jsonDecode(response.body);
    // print(responseData);
    return responseData
        .map((e) => Vehicle.fromJson(e as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Failed to get vehicle models.');
  }
}
// update listed vehicle
// deleted listed vehicle

// overview verfication

Future<List<VehicleVerificationOverview>> vehicleVerificationOverview(
    String id) async {
  final response =
      await genericGet(true, '$baseUrl/vehicle/$id/verification-overview');

  if (response.statusCode == 200) {
    final List<dynamic> responseData = jsonDecode(response.body);
    // print(responseData);
    return responseData
        .map((e) =>
            VehicleVerificationOverview.fromJson(e as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Failed to get vehicle models.');
  }
}
