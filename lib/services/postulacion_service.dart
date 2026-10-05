import 'dart:convert';

import 'package:postulaciones_app/models/api_response.dart';
import 'package:postulaciones_app/models/postulacion.dart';
import 'package:postulaciones_app/services/api_client.dart';

class PostulacionService {
  static const String apiUrl =
      'https://postulaciones-153a.onrender.com/api/postulaciones';

  final ApiClient _apiClient = ApiClient();

  Future<List<Postulacion>> obtenerPostulaciones() async {
    final response = await _apiClient.get(apiUrl);

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      throw Exception(json['message']);
    }

    final apiResponse = ApiResponse<List<Postulacion>>.fromJson(json, (data) {
      return (data as List)
          .map(
            (postulacion) =>
                Postulacion.fromJson(postulacion as Map<String, dynamic>),
          )
          .toList();
    });

    return apiResponse.data;
  }
}
