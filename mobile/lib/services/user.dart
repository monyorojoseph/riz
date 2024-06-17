import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:mobile/classes/user.dart';
import 'package:mobile/utils/storage.dart';

final storage = MyCustomSecureStorage();
// user ( slim )
Future<SlimUser> getSlimUser() async {
  String? access = await storage.read(key: "accessToken");

  final response = await http.get(Uri.parse('http://127.0.0.1:8000/user/slim'),
      headers: {"Authorization": "Bearer $access"});

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return SlimUser.fromJson(responseData);
  } else {
    throw Exception('Failed to get user details.');
  }
}

// user
Future<User> getUserDetails() async {
  String? access = await storage.read(key: "accessToken");

  final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/user/details'),
      headers: {"Authorization": "Bearer $access"});

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return User.fromJson(responseData);
  } else {
    throw Exception('Failed to get user details.');
  }
}

// update user

// upload pfp
// user verify
// user delete