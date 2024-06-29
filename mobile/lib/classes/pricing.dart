class Pricing {
  final int id;
  final String vehicle;
  final String period;
  final int amount;

  Pricing(
      {required this.id,
      required this.amount,
      required this.period,
      required this.vehicle});
  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
        id: json['id'] as int,
        amount: json['amount'] as int,
        period: json['period'] as String,
        vehicle: json['vehicle'] as String);
  }
}
