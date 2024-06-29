import 'dart:convert';

import 'package:http/http.dart';
import 'package:mobile/utils/storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

final storage = MyCustomSecureStorage();

// get
Future<Response> genericGet(bool authenticated, String url) async {
  if (authenticated) {
    String? access = await storage.read(key: "accessToken");

    return await http
        .get(Uri.parse(url), headers: {"Authorization": "Bearer $access"});
  }

  return await http.get(Uri.parse(url));
}

// // post
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
  return await http.post(Uri.parse(url), body: jsonEncode(data));
}

// put
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

// delete
Future<Response> genericDelete(String url) async {
  String? access = await storage.read(key: "accessToken");
  return await http
      .delete(Uri.parse(url), headers: {"Authorization": "Bearer $access"});
}

// post images
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
