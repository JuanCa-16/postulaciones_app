import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> guardarToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<String?> obtenerToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> eliminarToken() async {
    await _storage.delete(key: 'token');
  }
}
