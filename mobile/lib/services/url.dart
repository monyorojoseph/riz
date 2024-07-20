import 'dart:io';

// base url
class BaseUrl {
  static String get baseUrl {
    String url = 'http://127.0.0.1:8000';

    if (Platform.isAndroid) {
      url = 'http://10.0.2.2:8000';
    } else if (Platform.isIOS) {
      url = 'http://4.221.152.123:8000';
    }

    return url;
  }
}

final baseUrl = BaseUrl.baseUrl;
