import 'dart:convert';
import 'dart:async';
import 'package:mobile/classes/user.dart';
import 'package:mobile/services/url.dart';
import 'package:mobile/services/utils.dart';

// user ( slim )
Future<SlimUser> getSlimUser() async {
  final response = await appService.genericGet(true, '$baseUrl/user/slim');

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return SlimUser.fromJson(responseData);
  } else {
    throw Exception('Failed to get user details.');
  }
}

// user
Future<User> getUserDetails() async {
  final response = await appService.genericGet(true, '$baseUrl/user/details');

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return User.fromJson(responseData);
  } else {
    throw Exception('Failed to get user details.');
  }
}

// update user
Future<User> updateUserDetails(UpdateUser data) async {
  final response =
      await appService.genericPut('$baseUrl/user/update', data.toJson());

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return User.fromJson(responseData);
  } else {
    throw Exception('Failed to get user details.');
  }
}

// upload pfp
// user verify
// user delete

// user settings
// user settings (details)
Future<UserSetting> getUserSettingDetails() async {
  final response = await appService.genericGet(true, '$baseUrl/user-settings/');

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return UserSetting.fromJson(responseData);
  } else {
    throw Exception('Failed to get user details.');
  }
}

// user settings (update)
Future<UserSetting> updateUserSettingDetails(UpdateUserSetting data) async {
  final response = await appService.genericPut(
      '$baseUrl/user-settings/update', data.toJson());

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return UserSetting.fromJson(responseData);
  } else {
    throw Exception('Failed to get user settings details.');
  }
}
