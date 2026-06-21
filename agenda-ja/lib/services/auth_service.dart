import '../models/usuario.dart';
import 'api_client.dart';
import 'auth_session.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final _api = ApiClient.instance;
  final _session = AuthSession.instance;

  Future<Usuario> register({
    required String nome,
    required String email,
    required String senha,
    String? telefone,
  }) async {
    final data = await _api.post('/auth/register', body: {
      'nome': nome,
      'email': email,
      'senha': senha,
      if (telefone != null && telefone.isNotEmpty) 'telefone': telefone,
    });

    final token = data['token'] as String;
    final usuario = Usuario.fromJson(data['usuario'] as Map<String, dynamic>);
    await _session.save(token, usuario);
    return usuario;
  }

  Future<Usuario> login({
    required String email,
    required String senha,
  }) async {
    final data = await _api.post('/auth/login', body: {
      'email': email,
      'senha': senha,
    });

    final token = data['token'] as String;
    final usuario = Usuario.fromJson(data['usuario'] as Map<String, dynamic>);
    await _session.save(token, usuario);
    return usuario;
  }

  Future<void> logout() => _session.clear();

  Future<Usuario?> me() async {
    if (!_session.isLoggedIn) return null;
    final data = await _api.get('/auth/me', auth: true);
    final usuario = Usuario.fromJson(data['usuario'] as Map<String, dynamic>);
    await _session.save(_session.token!, usuario);
    return usuario;
  }
}
