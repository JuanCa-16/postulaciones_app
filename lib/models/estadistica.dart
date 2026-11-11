import 'package:flutter/animation.dart';
import 'package:postulaciones_app/models/estado.dart';
import 'package:postulaciones_app/models/modalidad.dart';

class EstadisticaEstado {
  final Estado estado;
  final int cantidad;
  final double porcentaje;

  EstadisticaEstado({
    required this.estado,
    required this.cantidad,
    required this.porcentaje,
  });

  int get estadoId => estado.id;
  String get nombre => estado.nombre;
  String get color => estado.color;
  bool get porDefecto => estado.porDefecto;
  Color get colorParsed => estado.colorParsed;

  factory EstadisticaEstado.fromJson(Map<String, dynamic> json) {
    return EstadisticaEstado(
      estado: Estado(
        id: json['estadoId'], // Mapea el estadoId del JSON al id del Estado
        nombre: json['nombre'],
        color: json['color'],
        porDefecto: json['porDefecto'],
      ),
      cantidad: json['cantidad'],
      porcentaje: (json['porcentaje'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ...estado.toJson(), // Reutiliza el toJson de Estado
      'cantidad': cantidad,
      'porcentaje': porcentaje,
    };
  }
}

class EstadisticaModalidad {
  final Modalidad modalidad;
  final int cantidad;
  final double porcentaje;

  EstadisticaModalidad({
    required this.modalidad,
    required this.cantidad,
    required this.porcentaje,
  });

  factory EstadisticaModalidad.fromJson(Map<String, dynamic> json) {
    return EstadisticaModalidad(
      modalidad: Modalidad.fromJson(json['modalidad']),
      cantidad: json['cantidad'],
      porcentaje: (json['porcentaje'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'modalidad': modalidad,
      'cantidad': cantidad,
      'porcentaje': porcentaje,
    };
  }
}

class EstadisticaFecha {
  final DateTime fecha;
  final int cantidad;

  EstadisticaFecha({required this.fecha, required this.cantidad});

  factory EstadisticaFecha.fromJson(Map<String, dynamic> json) {
    final p = (json['fecha'] as String).split('-').map(int.parse).toList();

    return EstadisticaFecha(
      fecha: DateTime(p[0], p[1], p[2]),
      cantidad: json['cantidad'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'fecha': fecha, 'cantidad': cantidad};
  }
}
