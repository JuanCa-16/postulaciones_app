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
}
