class Historial {
  final String campoActualizado;
  final String? valorAntiguo;
  final String valorNuevo;
  final String fechaActualizacion;

  const Historial({
    required this.campoActualizado,
    this.valorAntiguo,
    required this.valorNuevo,
    required this.fechaActualizacion,
  });

  String get fechaFormateada {
    if (fechaActualizacion.trim().isEmpty) return 'Sin fecha';
    final date = DateTime.tryParse(
      fechaActualizacion,
    ); // tryParse no crashea, devuelve null si falla
    if (date == null) return 'Fecha inválida';

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  String toString() {
    return 'Historial('
        'campoActualizado: $campoActualizado, '
        'valorAntiguo: $valorAntiguo, '
        'valorNuevo: $valorNuevo, '
        'fechaActualizacion: $fechaActualizacion'
        ')';
  }
}
