import 'package:mobile/classes/user.dart';

class VehicleBrand {
  final num id;
  final String name;
  final String category;

  const VehicleBrand(
      {required this.id, required this.name, required this.category});

  factory VehicleBrand.fromJson(Map<String, dynamic> json) {
    return VehicleBrand(
      id: json['id'] as num,
      name: json['name'] as String,
      category: json['category'] as String,
    );
  }
}

class VehicleModel {
  final num id;
  final String name;
  final num brand;

  const VehicleModel(
      {required this.id, required this.name, required this.brand});

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as num,
      name: json['name'] as String,
      brand: json['brand'] as num,
    );
  }
}

class Vehicle {
  final String id;
  final VehicleModel model;
  final VehicleBrand brand;
  final DateTime? yom;
  final String category;
  final String? contentType;
  final String? contentId;
  final bool display;
  final DateTime createdOn;
  final DateTime updatedOn;
  final List<VehicleImage>? images;
  final SlimUser? seller;

  Vehicle(
      {required this.id,
      required this.model,
      required this.brand,
      required this.category,
      this.yom,
      this.contentType,
      this.contentId,
      required this.display,
      required this.createdOn,
      required this.updatedOn,
      this.images,
      this.seller});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    var imagesJson = json['images'] as List<dynamic>?;
    List<VehicleImage>? images = imagesJson
        ?.map((img) => VehicleImage.fromJson(img as Map<String, dynamic>))
        .toList();
    return Vehicle(
        id: json['id'] as String,
        model: VehicleModel.fromJson(json['model'] as Map<String, dynamic>),
        brand: VehicleBrand.fromJson(json['brand'] as Map<String, dynamic>),
        category: json['category'] as String,
        display: json['display'] as bool,
        yom: json['yom'] != null ? DateTime.parse(json['yom'] as String) : null,
        createdOn: DateTime.parse(json['createdOn'] as String),
        updatedOn: DateTime.parse(json['updatedOn'] as String),
        seller: json['seller'] != null
            ? SlimUser.fromJson(json['seller'] as Map<String, dynamic>)
            : null,
        images: images);
  }
}

class VehicleImage {
  final int id;
  final String image;
  final bool coverImage;

  VehicleImage(
      {required this.id, required this.image, required this.coverImage});

  factory VehicleImage.fromJson(Map<String, dynamic> json) {
    return VehicleImage(
        id: json['id'] as int,
        image: json['image'] as String,
        coverImage: json['coverImage'] as bool);
  }
}

class LandVehicle {
  final int id;
  final String engineType;
  final int engineSize;
  final int? doors;
  final int passengers;
  final int load;
  final String fuelType;
  final String transmission;
  final String? drivetrain;
  final String type;

  LandVehicle(
      {required this.id,
      required this.engineType,
      required this.engineSize,
      this.doors,
      required this.passengers,
      required this.load,
      this.drivetrain,
      required this.fuelType,
      required this.transmission,
      required this.type});

  factory LandVehicle.fromJson(Map<String, dynamic> json) {
    return LandVehicle(
        id: json['id'] as int,
        engineType: json['engineType'] as String,
        engineSize: json['engineSize'] as int,
        passengers: json['passengers'] as int,
        load: json['load'] as int,
        doors: json['doors'] as int,
        drivetrain: json['drivetrain'] as String,
        fuelType: json['fuelType'] as String,
        transmission: json['transmission'] as String,
        type: json['type'] as String);
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'engineType': engineType,
  //     'engineSize': engineSize,
  //     'doors': doors,
  //     'passengers': passengers,
  //     'load': load,
  //     'fuelType': fuelType,
  //     'transmission': transmission,
  //     'drivetrain': drivetrain,
  //     'type': type,
  //   };
  // }
}

class VehicleVerificationOverview {
  final String stage;
  final String message;
  final bool passed;

  VehicleVerificationOverview(
      {required this.message, required this.passed, required this.stage});

  factory VehicleVerificationOverview.fromJson(Map<String, dynamic> json) {
    return VehicleVerificationOverview(
        message: json['message'] as String,
        passed: json['passed'] as bool,
        stage: json['stage'] as String);
  }
}