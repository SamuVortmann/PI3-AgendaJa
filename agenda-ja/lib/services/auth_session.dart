import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/usuario.dart';

class AuthSession {
  AuthSession._();
  static final AuthSession instance = AuthSession._();

  static const _tokenKey = 'auth_token';
  static const _usuarioKey = 'auth_usuario';

  String? token;
  Usuario? usuario;

  bool get isLoggedIn => token != null && usuario != null;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString(_tokenKey);
    final usuarioJson = prefs.getString(_usuarioKey);
    if (usuarioJson != null) {
      usuario = Usuario.fromJson(
        jsonDecode(usuarioJson) as Map<String, dynamic>,
      );
    }
  }

  Future<void> save(String newToken, Usuario newUsuario) async {
    token = newToken;
    usuario = newUsuario;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, newToken);
    await prefs.setString(_usuarioKey, jsonEncode(newUsuario.toJson()));
  }

  Future<void> clear() async {
    token = null;
    usuario = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_usuarioKey);
  }
}
