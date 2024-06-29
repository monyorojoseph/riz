import 'dart:io';

// base url
class BaseUrl {
  static String get baseUrl {
    // Default for iOS simulator and real devices
    String url = 'http://127.0.0.1:8000';

    // Use Android emulator loopback IP
    if (Platform.isAndroid) {
      url = 'http://10.0.2.2:8000';
    }

    return url;
  }
}

final baseUrl = BaseUrl.baseUrl;
