import 'package:flutter/material.dart';

class Estado {
  final int id;
  final String nombre;
  final String color;
  final bool porDefecto;

  const Estado({
    required this.id,
    required this.nombre,
    required this.color,
    required this.porDefecto,
  });

  Color get colorParsed {
    return Color(int.parse(color.replaceAll('#', '0xFF')));
  }

  factory Estado.fromJson(Map<String, dynamic> json) {
    return Estado(
      id: json['id'],
      nombre: json['nombre'],
      color: json['color'],
      porDefecto: json['porDefecto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'color': color,
      'porDefecto': porDefecto,
    };
  }

  EstadoFormulario toFormulario() {
    return EstadoFormulario(
      nombre: nombre,
      color: color,
      porDefecto: porDefecto,
    );
  }
}

class EstadoFormulario {
  final String nombre;
  final String color;
  final bool porDefecto;

  const EstadoFormulario({
    required this.nombre,
    required this.color,
    required this.porDefecto,
  });

  Color get colorParsed {
    return Color(int.parse(color.replaceAll('#', '0xFF')));
  }

  factory EstadoFormulario.fromJson(Map<String, dynamic> json) {
    return EstadoFormulario(
      nombre: json['nombre'],
      color: json['color'],
      porDefecto: json['porDefecto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'nombre': nombre, 'color': color, 'porDefecto': porDefecto};
  }
}
