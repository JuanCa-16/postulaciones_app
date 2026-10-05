enum Modalidad {
  REMOTO,
  HIBRIDO,
  PRESENCIAL;

  String get valor {
    switch (this) {
      case Modalidad.REMOTO:
        return 'REMOTO';
      case Modalidad.HIBRIDO:
        return 'HIBRIDO';
      case Modalidad.PRESENCIAL:
        return 'PRESENCIAL';
    }
  }

  factory Modalidad.fromJson(String valor) {
    switch (valor) {
      case 'REMOTO':
        return Modalidad.REMOTO;
      case 'HIBRIDO':
        return Modalidad.HIBRIDO;
      case 'PRESENCIAL':
        return Modalidad.PRESENCIAL;
      default:
        throw FormatException('Modalidad desconocida: $valor');
    }
  }
}
