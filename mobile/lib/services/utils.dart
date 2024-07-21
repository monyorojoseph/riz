import 'dart:convert';
import 'package:http/http.dart';
import 'package:acruda/utils/storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';

class AppService {
  final MyCustomSecureStorage storage = MyCustomSecureStorage();

  // Get request
  Future<Response> genericGet(bool authenticated, String url) async {
    if (authenticated) {
      String? access = await storage.read(key: "accessToken");
      return await http
          .get(Uri.parse(url), headers: {"Authorization": "Bearer $access"});
    }
    return await http.get(Uri.parse(url));
  }

  // Post request
  Future<Response> genericPost(
      bool authenticated, String url, dynamic data) async {
    if (authenticated) {
      String? access = await storage.read(key: "accessToken");
      return await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer $access",
        },
        body: jsonEncode(data),
      );
    }
    return await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
  }

  // Put request
  Future<Response> genericPut(String url, dynamic data) async {
    String? access = await storage.read(key: "accessToken");
    return await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer $access",
      },
      body: jsonEncode(data),
    );
  }

  // Delete request
  Future<Response> genericDelete(String url) async {
    String? access = await storage.read(key: "accessToken");
    return await http
        .delete(Uri.parse(url), headers: {"Authorization": "Bearer $access"});
  }

  // Upload images
  Future<StreamedResponse> uploadImages(String url, List<XFile> files) async {
    String? access = await storage.read(key: "accessToken");

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers['Authorization'] = "Bearer $access";
    for (var file in files) {
      request.files.add(await http.MultipartFile.fromPath('files', file.path));
    }
    var response = await request.send();
    return response;
  }

  // Upload image
  Future<StreamedResponse> uploadImage(String url, XFile file) async {
    String? access = await storage.read(key: "accessToken");

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers['Authorization'] = "Bearer $access";
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    var response = await request.send();
    return response;
  }
}

final appService = AppService();
