import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'auth_session.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  final AuthSession session = AuthSession.instance;

  Map<String, String> _headers({bool auth = false}) {
    final headers = {'Content-Type': 'application/json'};
    if (auth && session.token != null) {
      headers['Authorization'] = 'Bearer ${session.token}';
    }
    return headers;
  }

  Future<dynamic> get(String path, {bool auth = false}) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.apiUrl}$path'),
      headers: _headers(auth: auth),
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.apiUrl}$path'),
      headers: _headers(auth: auth),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.apiUrl}$path'),
      headers: _headers(auth: auth),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(String path, {bool auth = false}) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.apiUrl}$path'),
      headers: _headers(auth: auth),
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    dynamic body;
    if (response.body.isNotEmpty) {
      body = jsonDecode(response.body);
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    final message = body is Map && body['erro'] != null
        ? body['erro'] as String
        : 'Erro na requisição (${response.statusCode})';
    throw ApiException(message, statusCode: response.statusCode);
  }
}
