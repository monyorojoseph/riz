class VehicleRentalPolicy {
  final int id;
  final String vehicle;
  final bool latePenalty;
  final bool verifiedUser;
  final bool verifiedDl;

  VehicleRentalPolicy(
      {required this.id,
      required this.vehicle,
      required this.latePenalty,
      required this.verifiedDl,
      required this.verifiedUser});

  factory VehicleRentalPolicy.fromJson(Map<String, dynamic> json) {
    return VehicleRentalPolicy(
      id: json['id'],
      vehicle: json['vehicle'].toString(),
      latePenalty: json['latePenalty'] as bool,
      verifiedDl: json['verifiedDl'] as bool,
      verifiedUser: json['verifiedUser'] as bool,
    );
  }
}
