class SlimUser {
  final String id;
  final String fullName;
  final String email;
  final bool verifiedEmail;
  final bool verified;

  const SlimUser(
      {required this.id,
      required this.email,
      required this.fullName,
      required this.verifiedEmail,
      required this.verified});

  factory SlimUser.fromJson(Map<String, dynamic> json) {
    return SlimUser(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      verifiedEmail: json['verifiedEmail'] as bool,
      verified: json['verified'] as bool,
    );
  }
}

class User {
  final String id;
  final String fullName;
  final String email;
  final bool verifiedEmail;
  final bool verified;
  final String? phone;
  final String? sex;
  final String? profilePicture;
  final DateTime joinedOn;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.verifiedEmail,
    required this.verified,
    this.phone,
    this.sex,
    this.profilePicture,
    required this.joinedOn,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      verifiedEmail: json['verifiedEmail'] as bool,
      verified: json['verified'] as bool,
      phone: json['phone'] as String,
      sex: json['sex'] as String,
      profilePicture: json['profilePicture'] as String,
      joinedOn: DateTime.parse(json['joinedOn'] as String),
    );
  }
}
