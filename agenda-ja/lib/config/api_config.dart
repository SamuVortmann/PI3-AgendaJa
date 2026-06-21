import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiConfig {
  static const int port = 3000;

  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:$port';
    if (Platform.isAndroid) return 'http://10.0.2.2:$port';
    return 'http://localhost:$port';
  }

  static String get apiUrl => '$baseUrl/api';
}
