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
  final String model;
  final String brand;
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
}

class VehicleImage {
  final String id;
  final String image;
  final bool coverImage;

  VehicleImage(
      {required this.id, required this.image, required this.coverImage});
}
