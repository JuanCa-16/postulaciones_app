import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postulaciones_app/screens/login_screen.dart';
import 'package:postulaciones_app/services/token_service.dart';

class ApiClient {
  final TokenService _tokenService = TokenService();

  static GlobalKey<NavigatorState>? navigatorKey;

  static bool _redirigiendo = false;
  static void reiniciarRedireccion() => _redirigiendo = false;

  Future<http.Response> get(String url) async {
    final token = await _tokenService.obtenerToken();
    final response = await http.get(Uri.parse(url), headers: _headers(token));
    return _manejarRespuesta(response, token);
  }

  Future<http.Response> post(String url, {Object? body}) async {
    final token = await _tokenService.obtenerToken();
    final response = await http.post(
      Uri.parse(url),
      headers: _headers(token),
      body: body != null ? jsonEncode(body) : null,
    );
    return _manejarRespuesta(response, token);
  }

  Future<http.Response> patch(String url, {Object? body}) async {
    final token = await _tokenService.obtenerToken();
    final response = await http.patch(
      Uri.parse(url),
      headers: _headers(token),
      body: body != null ? jsonEncode(body) : null,
    );
    return _manejarRespuesta(response, token);
  }

  Future<http.Response> delete(String url) async {
    final token = await _tokenService.obtenerToken();
    final response = await http.delete(
      Uri.parse(url),
      headers: _headers(token),
    );
    return _manejarRespuesta(response, token);
  }

  Future<http.Response> _manejarRespuesta(
    http.Response response,
    String? token,
  ) async {
    // Solo si había token (así un 401 de login no te redirige)
    if (response.statusCode == 401 && token != null && !_redirigiendo) {
      _redirigiendo = true;

      await _tokenService.eliminarToken();

      navigatorKey?.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }

    return response;
  }

  Map<String, String> _headers(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
