import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile/classes/vehicle.dart';
import 'package:mobile/classes/vehiclerentalpolicy.dart';
import 'package:mobile/services/url.dart';
import 'package:mobile/services/utils.dart';
import 'package:image_picker/image_picker.dart';

// vehicle brand
Future<List<VehicleBrand>> getVehicleBrands() async {
  final response = await appService.genericGet(true, '$baseUrl/brand/all');

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
  final response = await appService.genericGet(
      true, '$baseUrl/brand/models?brandId=$brandId');

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
  final response =
      await appService.genericPost(true, '$baseUrl/vehicle/create', data);

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return Vehicle.fromJson(responseData);
  } else {
    throw Exception('Failed to create vehicle.');
  }
}

// create land vehicle
Future<LandVehicle> createLandVehicle(
    String vehicleId, Map<String, dynamic> data) async {
  final response = await appService.genericPost(
      true, '$baseUrl/land-vehicle/$vehicleId/create', data);

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return LandVehicle.fromJson(responseData);
  } else {
    throw Exception('Failed to create land.');
  }
}

// listed vehicle details
Future<Vehicle> listedVehicleDetails(String id) async {
  final response =
      await appService.genericGet(true, '$baseUrl/vehicle/$id/details');

  if (response.statusCode == 200) {
    final dynamic responseData = jsonDecode(response.body);
    // print(responseData);
    return Vehicle.fromJson(responseData as Map<String, dynamic>);
  } else {
    throw Exception('Failed to get vehicle details.');
  }
}

// my listed vehicles
Future<List<Vehicle>> myListedVehicles() async {
  final response = await appService.genericGet(true, '$baseUrl/user/vehicles');

  if (response.statusCode == 200) {
    final List<dynamic> responseData = jsonDecode(response.body);
    // print(responseData);
    return responseData
        .map((e) => Vehicle.fromJson(e as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Failed to get my listed vehicles.');
  }
}

// my listed vehicles
Future<List<VehicleImage>> vehicleImages(String id) async {
  final response =
      await appService.genericGet(true, '$baseUrl/vehicle-images/$id');

  if (response.statusCode == 200) {
    final List<dynamic> responseData = jsonDecode(response.body);
    // print(responseData);
    return responseData
        .map((e) => VehicleImage.fromJson(e as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Failed to get vehicle images');
  }
}

// update listed vehicle
Future<Vehicle> updateVehicle(
    String vehicleId, Map<String, dynamic> data) async {
  final response =
      await appService.genericPut('$baseUrl/vehicle/$vehicleId/update', data);

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return Vehicle.fromJson(responseData);
  } else {
    throw Exception('Failed to update vehicle details.');
  }
}
// deleted listed vehicle

// overview verfication
Future<List<VehicleVerificationOverview>> vehicleVerificationOverview(
    String id) async {
  final response = await appService.genericGet(
      true, '$baseUrl/vehicle/$id/verification-overview');

  if (response.statusCode == 200) {
    final List<dynamic> responseData = jsonDecode(response.body);
    // print(responseData);
    return responseData
        .map((e) =>
            VehicleVerificationOverview.fromJson(e as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Failed to get vehicle verification overview.');
  }
}

// land vehicle details
Future<LandVehicle> landVehicleDetails(String id) async {
  final response =
      await appService.genericGet(true, '$baseUrl/land-vehicle/$id/details');

  if (response.statusCode == 200) {
    final dynamic responseData = jsonDecode(response.body);
    // print(responseData);
    return LandVehicle.fromJson(responseData as Map<String, dynamic>);
  } else {
    throw Exception('Failed to get land vehicle details.');
  }
}

// update land vehicle
Future<LandVehicle> updateLandVehicle(
    String id, Map<String, dynamic> data) async {
  final response =
      await appService.genericPut('$baseUrl/land-vehicle/$id/update', data);

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return LandVehicle.fromJson(responseData);
  } else {
    throw Exception('Failed to update land vehicle details.');
  }
}

// get vehicle rental policy
Future<VehicleRentalPolicy> vehicleRentalPolicy(String vehicleId) async {
  final response =
      await appService.genericGet(true, '$baseUrl/vehicle-rules/$vehicleId');

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return VehicleRentalPolicy.fromJson(responseData);
  } else {
    throw Exception('Failed to get vehicle rental policy');
  }
}

// update vehicle rental policy
Future<VehicleRentalPolicy> updateVehicleRentalPolicy(
    String id, Map<String, dynamic> data) async {
  final response =
      await appService.genericPut('$baseUrl/vehicle-rules/$id/update', data);

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return VehicleRentalPolicy.fromJson(responseData);
  } else {
    throw Exception('Failed to get vehicle rental policy');
  }
}
// vehicle verification
// vehicle prove of ownership docs
// vehicle inspection docs
