import 'package:mobile/classes/user.dart';

class LoginUser {
  final String fullName;
  final String email;

  const LoginUser({
    required this.email,
    required this.fullName,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      email: json['email'] as String,
      fullName: json['fullName'] as String,
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
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
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
        refresh: json['refresh'] as String,
        access: json['access'] as String,
        user: SlimUser.fromJson(json['user'] as Map<String, dynamic>));
  }
}

class AuthVerificationPageArgs {
  final String email;
  final String fullName;

  AuthVerificationPageArgs(this.email, this.fullName);
}
