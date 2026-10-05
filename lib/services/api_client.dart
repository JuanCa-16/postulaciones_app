import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:postulaciones_app/services/token_service.dart';

class ApiClient {
  final TokenService _tokenService = TokenService();

  Future<http.Response> get(String url) async {
    final token = await _tokenService.obtenerToken();

    return await http.get(
      Uri.parse(url),
      headers: _headers(token),
    );
  }

  Future<http.Response> post(
    String url, {
    Object? body,
  }) async {
    final token = await _tokenService.obtenerToken();

    return await http.post(
      Uri.parse(url),
      headers: _headers(token),
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> patch(
    String url, {
    Object? body,
  }) async {
    final token = await _tokenService.obtenerToken();

    return await http.patch(
      Uri.parse(url),
      headers: _headers(token),
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> delete(String url) async {
    final token = await _tokenService.obtenerToken();

    return await http.delete(
      Uri.parse(url),
      headers: _headers(token),
    );
  }

  Map<String, String> _headers(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}