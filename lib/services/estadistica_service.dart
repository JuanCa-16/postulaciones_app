import 'dart:convert';

import 'package:postulaciones_app/config/environment.dart';
import 'package:postulaciones_app/models/api_response.dart';
import 'package:postulaciones_app/models/estadistica.dart';
import 'package:postulaciones_app/services/api_client.dart';

class EstadisticaService {
  final String apiUrl = Environment.estadisticasUrl;
  final ApiClient _apiClient = ApiClient();

  Future<List<EstadisticaEstado>> postulacionesPorEstado() async {
    final response = await _apiClient.get('$apiUrl/estados');

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      throw Exception(json['message']);
    }

    final apiResponse = ApiResponse<List<EstadisticaEstado>>.fromJson(json, (
      data,
    ) {
      return (data as List)
          .map(
            (estadistica) =>
                EstadisticaEstado.fromJson(estadistica as Map<String, dynamic>),
          )
          .toList();
    });

    return apiResponse.data;
  }

  Future<List<EstadisticaModalidad>> postulacionesPorModalidad() async {
    final response = await _apiClient.get('$apiUrl/modalidades');

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      throw Exception(json['message']);
    }

    final apiResponse = ApiResponse<List<EstadisticaModalidad>>.fromJson(json, (
      data,
    ) {
      return (data as List)
          .map(
            (estadistica) => EstadisticaModalidad.fromJson(
              estadistica as Map<String, dynamic>,
            ),
          )
          .toList();
    });

    return apiResponse.data;
  }

  Future<List<EstadisticaFecha>> postulacionesPorDia() async {
    final response = await _apiClient.get('$apiUrl/diarias');

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      throw Exception(json['message']);
    }

    final apiResponse = ApiResponse<List<EstadisticaFecha>>.fromJson(json, (
      data,
    ) {
      return (data as List)
          .map(
            (estadistica) =>
                EstadisticaFecha.fromJson(estadistica as Map<String, dynamic>),
          )
          .toList();
    });

    return apiResponse.data;
  }

  Future<List<RankingEstadistica>> _ranking(String ruta, int? estadoId) async {
    final uri = Uri.parse(
      '$apiUrl/$ruta',
    ).replace(queryParameters: {if (estadoId != null) 'estadoId': '$estadoId'});

    final response = await _apiClient.get(uri.toString());

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      throw Exception(json['message']);
    }

    final apiResponse = ApiResponse<List<RankingEstadistica>>.fromJson(json, (
      data,
    ) {
      return (data as List)
          .map((e) => RankingEstadistica.fromJson(e as Map<String, dynamic>))
          .toList();
    });

    return apiResponse.data;
  }

  Future<List<RankingEstadistica>> topEmpresas({int? estadoId}) =>
      _ranking('top-empresas', estadoId);

  Future<List<RankingEstadistica>> topPaginas({int? estadoId}) =>
      _ranking('top-paginas', estadoId);
}
