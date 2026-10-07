import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:postulaciones_app/models/api_response.dart';
import 'package:postulaciones_app/models/user_login.dart';
import 'package:postulaciones_app/services/api_client.dart';
import 'package:postulaciones_app/services/token_service.dart';

class AuthService {
  static const String apiUrl =
      'https://postulaciones-153a.onrender.com/api/auth';

  final TokenService _secureStorage = TokenService();

  Future<void> login(UserLogin usuario) async {
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toJson()),
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      throw Exception(json['message']);
    }

    final apiResponse = ApiResponse<UserLoginResponse>.fromJson(
      json,
      (data) => UserLoginResponse.fromJson(data as Map<String, dynamic>),
    );

    await _secureStorage.guardarToken(apiResponse.data.token);
    ApiClient.reiniciarRedireccion();
  }

  Future<String?> obtenerToken() async {
    return await _secureStorage.obtenerToken();
  }

  Future<void> logout() async {
    await _secureStorage.eliminarToken();
  }
}
