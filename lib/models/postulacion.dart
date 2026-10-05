import 'package:url_launcher/url_launcher.dart';

import 'estado.dart';
import 'historial.dart';
import 'modalidad.dart';

class PostulacionFormulario {
  final String nombreOferta;
  final String? nombreEmpresa;
  final String? url;
  final String? paginaAplicacion;
  final Modalidad modalidad;
  final int estadoId;

  const PostulacionFormulario({
    required this.nombreOferta,
    this.nombreEmpresa,
    this.url,
    this.paginaAplicacion,
    required this.modalidad,
    required this.estadoId,
  });

  @override
  String toString() {
    return 'PostulacionFormulario('
        'nombreOferta: $nombreOferta, '
        'nombreEmpresa: $nombreEmpresa, '
        'url: $url, '
        'paginaAplicacion: $paginaAplicacion, '
        'modalidad: ${modalidad.valor}, '
        'estadoId: $estadoId'
        ')';
  }

  Map<String, dynamic> toJson() {
    return {
      'nombreOferta': nombreOferta,
      'nombreEmpresa': nombreEmpresa,
      'url': url,
      'paginaAplicacion': paginaAplicacion,
      'modalidad': modalidad.valor,
      'estadoId': estadoId,
    };
  }
}

class Postulacion {
  final int id;
  final String nombreOferta;
  final String? nombreEmpresa;
  final String? url;
  final String? paginaAplicacion;
  final Modalidad modalidad;
  final String fecha;
  final Estado estado;
  final List<Historial>? historial;

  const Postulacion({
    required this.id,
    required this.nombreOferta,
    this.nombreEmpresa,
    this.url,
    this.paginaAplicacion,
    required this.modalidad,
    required this.fecha,
    required this.estado,
    this.historial,
  });

  String get fechaFormateada {
    if (fecha.trim().isEmpty) return 'Sin fecha';
    final date = DateTime.tryParse(
      fecha,
    ); // tryParse no crashea, devuelve null si falla
    if (date == null) return 'Fecha inválida';

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  PostulacionFormulario get datosParaFormulario {
    return PostulacionFormulario(
      nombreOferta: nombreOferta,
      nombreEmpresa: nombreEmpresa,
      url: url,
      paginaAplicacion: paginaAplicacion,
      modalidad: modalidad,
      estadoId: estado.id,
    );
  }

  Future<void> abrirUrl() async {
    if (url == null || url!.trim().isEmpty) return;
    final uri = Uri.tryParse(url!);
    if (uri == null || !uri.hasScheme) return;
    await launchUrl(uri);
  }

  @override
  String toString() {
    return 'Postulacion('
        'id: $id, '
        'nombreOferta: $nombreOferta, '
        'nombreEmpresa: $nombreEmpresa, '
        'url: $url, '
        'paginaAplicacion: $paginaAplicacion, '
        'modalidad: ${modalidad.valor}, '
        'fecha: $fecha, '
        'estado: ${estado.nombre}, '
        'historial: $historial'
        ')';
  }

  factory Postulacion.fromJson(Map<String, dynamic> json) {
    return Postulacion(
      id: json['id'],
      nombreOferta: json['nombreOferta'],
      nombreEmpresa: json['nombreEmpresa'],
      url: json['url'],
      paginaAplicacion: json['paginaAplicacion'],
      modalidad: Modalidad.fromJson(json['modalidad']),
      fecha: json['fecha'],
      estado: Estado.fromJson(json['estado']),
      historial: json['historial'] != null
          ? (json['historial'] as List)
                .map((item) => Historial.fromJson(item as Map<String, dynamic>))
                .toList()
          : null,
    );
  }
}
