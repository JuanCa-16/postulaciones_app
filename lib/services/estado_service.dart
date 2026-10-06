import 'dart:convert';

import 'package:postulaciones_app/models/api_response.dart';
import 'package:postulaciones_app/models/estado.dart';
import 'package:postulaciones_app/services/api_client.dart';

class EstadoService {
  static const String apiUrl =
      'https://postulaciones-153a.onrender.com/api/estados';

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
}
