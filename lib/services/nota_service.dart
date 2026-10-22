import 'dart:convert';

import 'package:postulaciones_app/config/environment.dart';
import 'package:postulaciones_app/models/api_response.dart';
import 'package:postulaciones_app/models/nota.dart';
import 'package:postulaciones_app/services/api_client.dart';

class NotaService {
  final String apiUrl = Environment.postulacionesUrl;
  final ApiClient _apiClient = ApiClient();

  Future<Nota?> obtenerNota(int id) async {
    final response = await _apiClient.get('$apiUrl/$id/nota');

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      throw Exception(json['message']);
    }

    final data = json['data'];
    if (data == null) return null; // no hay nota

    return Nota.fromJson(data as Map<String, dynamic>);
  }

  Future<Nota?> guardarNota(int id, Nota nota) async {
    final response = await _apiClient.put(
      '$apiUrl/$id/nota',
      body: nota.toJson(),
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      throw Exception(json['message']);
    }

    final data = json['data'];
    if (data == null) return null; // nota vacía / eliminada

    return Nota.fromJson(data as Map<String, dynamic>);
  }
}
