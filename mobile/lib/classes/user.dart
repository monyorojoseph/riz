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

class UpdateUser {
  final String? fullName;
  final String? email;
  final String? phone;
  final String? sex;

  const UpdateUser({this.email, this.fullName, this.phone, this.sex});

  // factory UpdateUser.fromJson(Map<String, dynamic> json) {
  //   return UpdateUser(
  //     email: json['email'] as String,
  //     fullName: json['fullName'] as String,
  //     phone: json['phone'] as String,
  //     sex: json['sex'] as String,
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'sex': sex,
    };
  }
}

class UserSetting {
  final String id;
  final String user;
  final String appPurpose;
  final String currentScreen;

  const UserSetting({
    required this.id,
    required this.user,
    required this.appPurpose,
    required this.currentScreen,
  });

  factory UserSetting.fromJson(Map<String, dynamic> json) {
    return UserSetting(
        id: json['id'].toString(),
        user: json['user'].toString(),
        appPurpose: json['appPurpose'].toString(),
        currentScreen: json['currentScreen'].toString());
  }
}

class UpdateUserSetting {
  final String? appPurpose;
  final String? currentScreen;

  const UpdateUserSetting({
    this.appPurpose,
    this.currentScreen,
  });

  factory UpdateUserSetting.fromJson(Map<String, dynamic> json) {
    return UpdateUserSetting(
      appPurpose: json['appPurpose'] as String,
      currentScreen: json['currentScreen'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {'appPurpose': appPurpose, 'currentScreen': currentScreen};
  }
}
