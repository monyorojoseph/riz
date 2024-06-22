import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mobile/classes/auth.dart';

// login
Future<LoginUser> loginUser(String email, String password) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/auth/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return LoginUser.fromJson(responseData);
  } else {
    throw Exception('Failed to create an account.');
  }
}

// register

Future<RegisterUser> registerUser(
    String email, String password, String fullName) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/auth/registration'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
      'fullName': fullName,
    }),
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
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/auth/token'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'token': token,
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return AuthenticatedUser.fromJson(responseData);
  } else {
    throw Exception('Failed to verify your token');
  }
}

// logout
Future<Response> logoutUser(String access) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/auth/logout'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'access': access,
    }),
  );
  return response;
}
// refresh tokens