import 'package:acruda/classes/user.dart';

class LoginUser {
  final String fullName;
  final String email;

  const LoginUser({
    required this.email,
    required this.fullName,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      email: json['email'].toString(),
      fullName: json['fullName'].toString(),
    );
  }
}

class RegisterUser {
  final String id;
  final String fullName;
  final String email;

  const RegisterUser({
    required this.id,
    required this.email,
    required this.fullName,
  });

  factory RegisterUser.fromJson(Map<String, dynamic> json) {
    return RegisterUser(
      id: json['id'].toString(),
      email: json['email'].toString(),
      fullName: json['fullName'].toString(),
    );
  }
}

class AuthenticatedUser {
  final String refresh;
  final String access;
  final SlimUser user;

  const AuthenticatedUser(
      {required this.refresh, required this.access, required this.user});

  factory AuthenticatedUser.fromJson(Map<String, dynamic> json) {
    return AuthenticatedUser(
        refresh: json['refresh'].toString(),
        access: json['access'].toString(),
        user: SlimUser.fromJson(json['user'] as Map<String, dynamic>));
  }
}
