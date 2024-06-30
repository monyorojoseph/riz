import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart';
import 'package:mobile/classes/auth.dart';
import 'package:mobile/services/url.dart';
import 'package:mobile/services/utils.dart';

// login
Future<LoginUser> loginUser(String email, String password) async {
  final response = await appService.genericPost(
    false,
    '$baseUrl/auth/login',
    {
      'email': email,
      'password': password,
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return LoginUser.fromJson(responseData);
  } else {
    throw Exception('Failed to login.');
  }
}

// register

Future<RegisterUser> registerUser(
    String email, String password, String fullName) async {
  final response = await appService.genericPost(
    false,
    '$baseUrl/auth/registration',
    {
      'email': email,
      'password': password,
      'fullName': fullName,
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return RegisterUser.fromJson(responseData);
  } else {
    throw Exception('Failed to create an account.');
  }
}

// verify token and get auth tokens

Future<AuthenticatedUser> getAuthTokens(String token) async {
  final response = await appService
      .genericPost(false, '$baseUrl/auth/token', {'token': token});

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return AuthenticatedUser.fromJson(responseData);
  } else {
    throw Exception('Failed to verify your token');
  }
}

// logout
Future<Response> logoutUser(String access) async {
  final response = await appService.genericPost(
    false,
    '$baseUrl/auth/logout',
    {'access': access},
  );
  return response;
}
// refresh tokens