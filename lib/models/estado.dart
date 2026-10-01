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
}
