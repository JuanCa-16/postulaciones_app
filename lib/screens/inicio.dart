import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:postulaciones_app/constants/app_strings.dart';
import 'package:postulaciones_app/models/criterios_busqueda.dart';
import 'package:postulaciones_app/models/estado.dart';
import 'package:postulaciones_app/models/modalidad.dart';
import 'package:postulaciones_app/models/postulacion.dart';
import 'package:postulaciones_app/screens/conf_estados.dart';
import 'package:postulaciones_app/screens/crear_postulacion.dart';
import 'package:postulaciones_app/screens/login_screen.dart';
import 'package:postulaciones_app/services/estado_service.dart';
import 'package:postulaciones_app/services/postulacion_service.dart';
import 'package:postulaciones_app/services/token_service.dart';
import 'package:postulaciones_app/theme/app_colors.dart';
import 'package:postulaciones_app/utils/async_handler.dart';
import 'package:postulaciones_app/widgets/dashed_line.dart';
import 'package:postulaciones_app/widgets/filtros_postulaciones.dart';
import 'package:postulaciones_app/widgets/input_field.dart';
import 'package:postulaciones_app/widgets/loading_overlay.dart';
import 'package:postulaciones_app/widgets/postulacion_card.dart';
import 'package:postulaciones_app/screens/detalles_postulacion.dart';
import 'package:postulaciones_app/widgets/confirm_dialog.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final PostulacionService _postulacionService = PostulacionService();
  final EstadoService _estadoService = EstadoService();
  final TokenService _tokenService = TokenService();

  int? postulacionExpandida;
  List<Postulacion> postulaciones = [];

  List<Estado> estados = [];

  Set<int> estadosSeleccionados = {};
  Set<Modalidad> modalidadesSeleccionadas = {};
  CriterioBusqueda criterioBusqueda = CriterioBusqueda.TODO;

  String busqueda = '';

  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosIniciales();
  }

  Future<void> _cargarDatosIniciales() async {
    await AsyncHandler.ejecutar(
      context,
      tituloError: AppStrings.errorCargar,
      onLoading: (cargando) => setState(() => this.cargando = cargando),
      accion: () async {
        final resultados = await Future.wait([
          _postulacionService.obtenerPostulaciones(),
          _estadoService.obtenerEstados(),
        ]);

        if (!mounted) return;

        final postulacionesCargadas = resultados[0] as List<Postulacion>;
        final estadosCargados = resultados[1] as List<Estado>;

        setState(() {
          postulaciones = postulacionesCargadas;
          estados = estadosCargados;
        });
      },
    );
  }

  Future<void> _cargarEstados() async {
    await AsyncHandler.ejecutar(
      context,
      tituloError: AppStrings.errorCargar,
      onLoading: (cargando) => setState(() => this.cargando = cargando),
      accion: () async {
        final resultado = await _estadoService.obtenerEstados();

        if (!mounted) return;

        setState(() {
          estados = resultado;
        });
      },
    );
  }

  Future<void> _cargarPostulaciones({bool silencioso = false}) async {
    await AsyncHandler.ejecutar(
      context,
      tituloError: AppStrings.errorCargar,
      onLoading: (cargando) => {
        if (!silencioso) setState(() => this.cargando = cargando),
      },
      accion: () async {
        final resultado = await _postulacionService.obtenerPostulaciones();

        if (!mounted) return;

        setState(() {
          postulaciones = resultado;
          cargando = false;
        });
      },
    );
  }

  Future<void> _eliminarPostulacion(int id) async {
    await AsyncHandler.ejecutar(
      context,
      tituloError: AppStrings.errorEliminar,
      onLoading: (cargando) => setState(() => this.cargando = cargando),
      accion: () async {
        await _postulacionService.eliminarPostulacion(id);

        if (!mounted) return;
        await _cargarPostulaciones();
      },
    );
  }

  List<Postulacion> get postulacionesFiltradas {
    final texto = busqueda.toLowerCase().trim();

    return postulaciones.where((postulacion) {
      final oferta = postulacion.nombreOferta.toLowerCase();
      final empresa = postulacion.nombreEmpresa?.toLowerCase() ?? '';
      final pagina = postulacion.paginaAplicacion?.toLowerCase() ?? '';

      // 1. Criterio de búsqueda
      String textoDondeBuscar;

      switch (criterioBusqueda) {
        case CriterioBusqueda.TODO:
          textoDondeBuscar = '$oferta $empresa $pagina';
        case CriterioBusqueda.OFERTA:
          textoDondeBuscar = oferta;
        case CriterioBusqueda.EMPRESA:
          textoDondeBuscar = empresa;
        case CriterioBusqueda.PAGINA:
          textoDondeBuscar = pagina;
      }

      // 2. Buscar todas las palabras
      final palabras = texto.split(RegExp(r'\s+'));

      final coincideTexto =
          texto.isEmpty ||
          palabras.every((palabra) => textoDondeBuscar.contains(palabra));

      final coincideEstado =
          estadosSeleccionados.isEmpty ||
          estadosSeleccionados.contains(postulacion.estado.id);

      // 4. Filtrar por modalidades
      final coincideModalidad =
          modalidadesSeleccionadas.isEmpty ||
          modalidadesSeleccionadas.contains(postulacion.modalidad);

      return coincideTexto && coincideEstado && coincideModalidad;
    }).toList();
  }

  void _confirmarCerrarSesion() {
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          title: AppStrings.cerrarSesion,
          message: AppStrings.confirmarCerrarSesion,
          onConfirm: _cerrarSesion,
        );
      },
    );
  }

  Future<void> _cerrarSesion() async {
    await _tokenService.eliminarToken();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _abrirFiltros() async {
    FocusManager.instance.primaryFocus?.unfocus();

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSheet) {
            void actualizarFiltros(VoidCallback accion) {
              setState(() {
                accion();
              });

              setStateSheet(() {});
            }

            return FiltrosPostulaciones(
              estados: estados,
              estadosSeleccionados: estadosSeleccionados,
              modalidadesSeleccionadas: modalidadesSeleccionadas,
              criterioBusqueda: criterioBusqueda,

              onEstadosChanged: (seleccionados) {
                actualizarFiltros(() {
                  estadosSeleccionados = seleccionados;
                });
              },

              onModalidadesChanged: (seleccionadas) {
                actualizarFiltros(() {
                  modalidadesSeleccionadas = seleccionadas;
                });
              },

              onCriterioChanged: (criterio) {
                actualizarFiltros(() {
                  criterioBusqueda = criterio;
                });
              },

              onLimpiar: () {
                actualizarFiltros(() {
                  estadosSeleccionados.clear();
                  modalidadesSeleccionadas.clear();
                  criterioBusqueda = CriterioBusqueda.TODO;
                });
              },
            );
          },
        );
      },
    );
  }

  int get cantidadFiltrosActivos {
    return estadosSeleccionados.length +
        modalidadesSeleccionadas.length +
        (criterioBusqueda != CriterioBusqueda.TODO ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      loading: cargando,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.misPostulaciones),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: AppStrings.configuracionEstados,
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConfEstados()),
                  );

                  if (!mounted) return;
                  FocusManager.instance.primaryFocus?.unfocus();
                  await _cargarPostulaciones();
                  await _cargarEstados();
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout_rounded),
                tooltip: AppStrings.cerrarSesion,
                onPressed: _confirmarCerrarSesion,
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InputField(
                            placeholder:
                                AppStrings.placeholderBuscarPostulacion,
                            keyboardType: TextInputType.text,
                            onChanged: (valor) =>
                                setState(() => busqueda = valor ?? ''),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Badge(
                          isLabelVisible: cantidadFiltrosActivos > 0,
                          label: Text(
                            '$cantidadFiltrosActivos',
                            style: TextStyle(color: context.colors.background),
                          ),
                          backgroundColor: context.colors.mainColor,
                          child: IconButton.filledTonal(
                            icon: const Icon(Icons.filter_list_rounded),
                            tooltip: 'Filtrar por estado',
                            onPressed: _abrirFiltros,
                            style: IconButton.styleFrom(
                              backgroundColor: context
                                  .colors
                                  .inputBackground, // fondo del círculo
                              foregroundColor: context
                                  .colors
                                  .textSecondary, // color del ícono
                              // borde (opcional)
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DashedLine(
                      text:
                          '${postulacionesFiltradas.length} ${AppStrings.cantPostulaciones}',
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SlidableAutoCloseBehavior(
                  child: RefreshIndicator(
                    color: context.colors.mainColor,
                    onRefresh: () => _cargarPostulaciones(silencioso: true),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: postulacionesFiltradas.length,
                      itemBuilder: (context, index) {
                        final postulacion = postulacionesFiltradas[index];

                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 12,
                          ), // Espaciado vertical entre tarjetas
                          child: PostulacionCard(
                            key: ValueKey(postulacion.id),
                            postulacion: postulacion,
                            expandido: postulacionExpandida == postulacion.id,
                            onTap: () {
                              setState(() {
                                postulacionExpandida =
                                    postulacionExpandida == postulacion.id
                                    ? null
                                    : postulacion.id;
                              });
                            },
                            onDetalles: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetallesPostulacion(
                                    postulacion: postulacion,
                                  ),
                                ),
                              );

                              if (!mounted) return;
                              FocusManager.instance.primaryFocus?.unfocus();
                              await _cargarPostulaciones();
                              await _cargarEstados();
                            },
                            onEliminar: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ConfirmDialog(
                                    title: AppStrings.eliminar,
                                    message: AppStrings.confirmarEliminacion,
                                    confirmText: AppStrings.eliminar,
                                    onConfirm: () =>
                                        _eliminarPostulacion(postulacion.id),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CrearPostulacion(),
                ),
              );

              if (!mounted) return;
              FocusManager.instance.primaryFocus?.unfocus();
              await _cargarPostulaciones();
              await _cargarEstados();
            },
            child: Icon(
              Icons.add,
              color: context.colors.background,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
