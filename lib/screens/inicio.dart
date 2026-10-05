import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:postulaciones_app/models/postulacion.dart';
import 'package:postulaciones_app/screens/crear_postulacion.dart';
import 'package:postulaciones_app/services/postulacion_service.dart';
import 'package:postulaciones_app/theme/app_colors.dart';
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
  int? postulacionExpandida;
  List<Postulacion> postulaciones = [];
  bool cargando = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _cargarPostulaciones();
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

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      loading: cargando,
      child: Scaffold(
        appBar: AppBar(title: Text('MIS POSTULACIONES'),),
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
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: SlidableAutoCloseBehavior(
                  closeWhenOpened: true,
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: postulaciones.map((postulacion) {
                      return PostulacionCard(
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
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetallesPostulacion(postulacion: postulacion),
                            ),
                          );

                          if (!mounted) return;

                          await _cargarPostulaciones();
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
                                onConfirm: () {
                                  // Lógica para eliminar postulación
                                },
                              );
                            },
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.buttonPrimary,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CrearPostulacion()),
            );
          },
          child: const Icon(Icons.add, color: AppColors.inputBackground),
        ),
      ),
    );
  }
}
