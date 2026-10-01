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
}
