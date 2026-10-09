import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:postulaciones_app/constants/app_strings.dart';
import 'package:postulaciones_app/models/estado.dart';
import 'package:postulaciones_app/models/postulacion.dart';
import 'package:postulaciones_app/screens/conf_estados.dart';
import 'package:postulaciones_app/screens/crear_postulacion.dart';
import 'package:postulaciones_app/screens/login_screen.dart';
import 'package:postulaciones_app/services/estado_service.dart';
import 'package:postulaciones_app/services/postulacion_service.dart';
import 'package:postulaciones_app/services/token_service.dart';
import 'package:postulaciones_app/theme/app_colors.dart';
import 'package:postulaciones_app/utils/async_handler.dart';
import 'package:postulaciones_app/widgets/chip_option.dart';
import 'package:postulaciones_app/widgets/dashed_line.dart';
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

  bool cargando = true;
  String busqueda = '';

  @override
  void initState() {
    super.initState();
    _cargarPostulaciones();
    _cargarEstados();
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

  List<Postulacion> get postulacionesFiltradas {
    final texto = busqueda.toLowerCase().trim();

    return postulaciones.where((postulacion) {
      final oferta = postulacion.nombreOferta.toLowerCase();
      final empresa = postulacion.nombreEmpresa?.toLowerCase() ?? '';

      final coincideTexto =
          texto.isEmpty || oferta.contains(texto) || empresa.contains(texto);

      final coincideEstado =
          estadosSeleccionados.isEmpty ||
          estadosSeleccionados.contains(postulacion.estado.id);

      return coincideTexto && coincideEstado;
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

    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        // StatefulBuilder: para que los chips se actualicen dentro del sheet
        return StatefulBuilder(
          builder: (context, setStateSheet) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        AppStrings.filtroEstado,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      if (estadosSeleccionados.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            setState(() => estadosSeleccionados.clear());
                            setStateSheet(() {});
                          },
                          child: const Text(AppStrings.limpiar),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      alignment: WrapAlignment.center,
                      children: estados.map((estado) {
                        final seleccionado = estadosSeleccionados.contains(
                          estado.id,
                        );

                        return ChipOption(
                          label: estado.nombre,
                          selected: seleccionado,
                          color: estado.colorParsed,
                          showDot: true,
                          unselectedFill: Colors.transparent,
                          onSelected: (v) {
                            setState(() {
                              v
                                  ? estadosSeleccionados.add(estado.id)
                                  : estadosSeleccionados.remove(estado.id);
                            });
                            setStateSheet(() {});
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
                          isLabelVisible: estadosSeleccionados.isNotEmpty,
                          label: Text(
                            '${estadosSeleccionados.length}',
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
