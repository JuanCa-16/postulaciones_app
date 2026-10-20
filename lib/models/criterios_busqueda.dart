enum CriterioBusqueda {
  TODO,
  OFERTA,
  EMPRESA,
  PAGINA;

  String get nombreCriterio {
    switch (this) {
      case CriterioBusqueda.TODO:
        return 'Todo';
      case CriterioBusqueda.OFERTA:
        return 'Oferta';
      case CriterioBusqueda.EMPRESA:
        return 'Empresa';
      case CriterioBusqueda.PAGINA:
        return 'Página';
    }
  }
}
