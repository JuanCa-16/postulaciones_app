class Nota {
  final String? reclutador;
  final String? salario;
  final String? ubicacion;
  final String? horario;
  final String? tipoContrato;
  final String? otros;
  final String? fechaActualizacion;

  const Nota({
    this.reclutador,
    this.salario,
    this.ubicacion,
    this.horario,
    this.tipoContrato,
    this.otros,
    this.fechaActualizacion,
  });

  factory Nota.fromJson(Map<String, dynamic> json) {
    return Nota(
      reclutador: json['reclutador'] as String?,
      salario: json['salario'] as String?,
      ubicacion: json['ubicacion'] as String?,
      horario: json['horario'] as String?,
      tipoContrato: json['tipoContrato'] as String?,
      otros: json['otros'] as String?,
      fechaActualizacion: json['fechaActualizacion'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reclutador': reclutador,
      'salario': salario,
      'ubicacion': ubicacion,
      'horario': horario,
      'tipoContrato': tipoContrato,
      'otros': otros,
      'fechaActualizacion': fechaActualizacion,
    };
  }
}
