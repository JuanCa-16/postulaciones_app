import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get apiBaseUrl {
    final url = dotenv.env['API_BASE_URL'];

    // Si la variable no existe en el .env, la app avisará explícitamente en desarrollo
    if (url == null || url.isEmpty) {
      throw Exception('Falta definir API_BASE_URL en el archivo .env');
    }

    return url;
  }

  static String get estadosUrl => '$apiBaseUrl/estados';
  static String get postulacionesUrl => '$apiBaseUrl/postulaciones';
  static String get authUrl => '$apiBaseUrl/auth';
}
