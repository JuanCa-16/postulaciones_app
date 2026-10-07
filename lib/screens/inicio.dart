import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:postulaciones_app/models/estado.dart';
import 'package:postulaciones_app/models/postulacion.dart';
import 'package:postulaciones_app/screens/conf_estados.dart';
import 'package:postulaciones_app/screens/crear_postulacion.dart';
import 'package:postulaciones_app/screens/login._screen.dart';
import 'package:postulaciones_app/services/estado_service.dart';
import 'package:postulaciones_app/services/postulacion_service.dart';
import 'package:postulaciones_app/services/token_service.dart';
import 'package:postulaciones_app/theme/app_colors.dart';
import 'package:postulaciones_app/widgets/dashed_line.dart';
import 'package:postulaciones_app/widgets/dialog_helper.dart';
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
  String? error;
  String busqueda = '';

  @override
  void initState() {
    super.initState();
    _cargarPostulaciones();
    _cargarEstados();
  }

  Future<void> _cargarPostulaciones() async {
    setState(() {
      cargando = true;
      error = null;
    });

    try {
      final resultado = await _postulacionService.obtenerPostulaciones();

      if (!mounted) return;

      setState(() {
        postulaciones = resultado;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      final mensaje = e.toString().replaceFirst('Exception: ', '');

      setState(() {
        cargando = false;
        error = mensaje;
      });
    }
  }

  Future<void> _eliminarPostulacion(int id) async {
    setState(() {
      cargando = true;
    });

    try {
      await _postulacionService.eliminarPostulacion(id);

      if (!mounted) return;
      await _cargarPostulaciones();
    } catch (e) {
      if (!mounted) return;

      final mensaje = e.toString().replaceFirst('Exception: ', '');

      await DialogHelper.mostrarError(
        context,
        mensaje,
        titulo: 'Error al eliminar postulacion',
      );
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  Future<void> _cargarEstados() async {
    try {
      final resultado = await _estadoService.obtenerEstados();

      if (!mounted) return;

      setState(() {
        estados = resultado;
      });
    } catch (e) {
      if (!mounted) return;
    }
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
          title: 'Cerrar sesión',
          message: '¿Estás seguro de que deseas cerrar sesión?',
          confirmText: 'Cerrar sesión',
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

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      loading: cargando,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('MIS POSTULACIONES'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Configuracion Estados',
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
                tooltip: 'Cerrar sesión',
                onPressed: _confirmarCerrarSesion,
              ),
            ],
          ),
          body: error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'No se pudieron cargar las postulaciones',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(error!, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _cargarPostulaciones,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InputField(
                            label: 'Buscar postulación',
                            placeholder: 'Ej. Frontend Developer, Google...',
                            keyboardType: TextInputType.text,
                            onChanged: (valor) {
                              setState(() {
                                busqueda = valor ?? '';
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              spacing: 8,
                              alignment: WrapAlignment.start,
                              children: estados.map((estado) {
                                return ChoiceChip(
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color:
                                              estadosSeleccionados.contains(
                                                estado.id,
                                              )
                                              ? Colors.white
                                              : estado.colorParsed,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        estado.nombre,
                                        style: TextStyle(
                                          color:
                                              estadosSeleccionados.contains(
                                                estado.id,
                                              )
                                              ? Colors.white
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  selected: estadosSeleccionados.contains(
                                    estado.id,
                                  ),
                                  showCheckmark: false,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(
                                      color:
                                          estadosSeleccionados.contains(
                                            estado.id,
                                          )
                                          ? estado.colorParsed
                                          : AppColors.inputFocusedBorder,
                                      width: 1,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  labelPadding: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  color: WidgetStateColor.resolveWith((states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return estado.colorParsed;
                                    }

                                    return Colors.transparent;
                                  }),

                                  onSelected: (seleccionado) {
                                    setState(() {
                                      if (seleccionado) {
                                        estadosSeleccionados.add(estado.id);
                                      } else {
                                        estadosSeleccionados.remove(estado.id);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),

                          DashedLine(
                            text:
                                '${postulacionesFiltradas.length} POSTULACIONES',
                          ),

                          // Aquí podrías agregar un TextField de búsqueda o chips de filtros
                        ],
                      ),
                    ),
                    Expanded(
                      child: SlidableAutoCloseBehavior(
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
                                expandido:
                                    postulacionExpandida == postulacion.id,
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
                                        title: 'Eliminar postulación',
                                        message:
                                            '¿Estás seguro de que deseas eliminar esta postulación?',
                                        confirmText: 'Eliminar',
                                        onConfirm: () => _eliminarPostulacion(
                                          postulacion.id,
                                        ),
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
                  ],
                ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.buttonPrimary,
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
            child: const Icon(Icons.add, color: AppColors.inputBackground),
          ),
        ),
      ),
    );
  }
}
