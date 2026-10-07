import 'dart:convert';

import 'package:postulaciones_app/config/environment.dart';
import 'package:postulaciones_app/models/api_response.dart';
import 'package:postulaciones_app/models/estado.dart';
import 'package:postulaciones_app/services/api_client.dart';

class EstadoService {
  final String apiUrl = Environment.estadosUrl;
  final ApiClient _apiClient = ApiClient();

  Future<List<Estado>> obtenerEstados() async {
    final response = await _apiClient.get(apiUrl);

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      throw Exception(json['message']);
    }

    final apiResponse = ApiResponse.fromJson(json, (data) {
      return (data as List)
          .map((estado) => Estado.fromJson(estado as Map<String, dynamic>))
          .toList();
    });

    return apiResponse.data;
  }

  Future<void> crearEstado(EstadoFormulario estado) async {
    final response = await _apiClient.post(apiUrl, body: estado.toJson());

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(json['message']);
    }
  }

  Future<Estado> editarEstado(int id, EstadoFormulario estado) async {
    final response = await _apiClient.patch(
      '$apiUrl/$id',
      body: estado.toJson(),
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      throw Exception(json['message']);
    }

    final apiResponse = ApiResponse.fromJson(
      json,
      (data) => Estado.fromJson(data as Map<String, dynamic>),
    );

    return apiResponse.data;
  }

  Future<void> eliminarEstado(int id) async {
    final response = await _apiClient.delete('$apiUrl/$id');

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      throw Exception(json['message']);
    }
  }
}
