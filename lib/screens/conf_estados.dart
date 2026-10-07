import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:postulaciones_app/layouts/card_layout.dart';
import 'package:postulaciones_app/models/estado.dart';
import 'package:postulaciones_app/services/estado_service.dart';
import 'package:postulaciones_app/widgets/dashed_line.dart';
import 'package:postulaciones_app/widgets/dialog_helper.dart';
import 'package:postulaciones_app/widgets/estado_card.dart';
import 'package:postulaciones_app/widgets/loading_overlay.dart';

class ConfEstados extends StatefulWidget {
  const ConfEstados({super.key});

  @override
  State<ConfEstados> createState() => _ConfEstadosState();
}

class _ConfEstadosState extends State<ConfEstados> {
  final EstadoService _estadoService = EstadoService();
  List<Estado> estados = [];
  bool cargando = false;

  @override
  void initState() {
    super.initState();
    _cargarEstados();
  }

  Future<void> _cargarEstados() async {
    setState(() {
      cargando = true;
    });
    try {
      final resultado = await _estadoService.obtenerEstados();

      if (!mounted) return;

      setState(() {
        estados = resultado;
      });
    } catch (e) {
      if (!mounted) return;

      final mensaje = e.toString().replaceFirst('Exception: ', '');

      await DialogHelper.mostrarError(
        context,
        mensaje,
        titulo: 'Error al consultar estados',
      );
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  Future<void> _editarEstado(int id, EstadoFormulario estado) async {
    setState(() {
      cargando = true;
    });

    try {
      await _estadoService.editarEstado(id, estado);

      if (!mounted) return;
      await _cargarEstados();
    } catch (e) {
      if (!mounted) return;

      final mensaje = e.toString().replaceFirst('Exception: ', '');

      await DialogHelper.mostrarError(
        context,
        mensaje,
        titulo: 'Error al editar estado',
      );
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  Future<void> _crearEstado(EstadoFormulario estado) async {
    setState(() {
      cargando = true;
    });

    try {
      await _estadoService.crearEstado(estado);

      if (!mounted) return;
      await _cargarEstados();
    } catch (e) {
      if (!mounted) return;

      final mensaje = e.toString().replaceFirst('Exception: ', '');

      await DialogHelper.mostrarError(
        context,
        mensaje,
        titulo: 'Error al crear estado',
      );
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  Future<void> _eliminarEstado(int id) async {
    setState(() {
      cargando = true;
    });

    try {
      await _estadoService.eliminarEstado(id);

      if (!mounted) return;
      await _cargarEstados();
    } catch (e) {
      if (!mounted) return;

      final mensaje = e.toString().replaceFirst('Exception: ', '');

      await DialogHelper.mostrarError(
        context,
        mensaje,
        titulo: 'Error al eliminar estado',
      );
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  String colorAHex(Color c) {
    final rgb = c.toARGB32() & 0xFFFFFF;
    return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      loading: cargando,
      variant: true,
      child: Scaffold(
        body: estados.isEmpty
            ? const SizedBox.shrink()
            : CardLayout(
                title: 'Configuración de Estados',
                description:
                    'Gestiona y personaliza las etiquetas de tus postulaciones',
                child: SlidableAutoCloseBehavior(
                  child: Column(
                    children: [
                      if (estados.length >= 5) ...[
                        const DashedLine(text: 'Max de Estados Creados'),
                        const SizedBox(height: 10),
                      ],

                      ...estados.map(
                        (estado) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: EstadoCard(
                            key: ValueKey(estado.id),
                            estado: estado.toFormulario(),
                            onEliminar: () => _eliminarEstado(estado.id),
                            onGuardar: (nombre, color, porDefecto) {
                              _editarEstado(
                                estado.id,
                                EstadoFormulario(
                                  nombre: nombre,
                                  color: colorAHex(color),
                                  porDefecto: porDefecto,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      if (estados.length < 5) ...[
                        const SizedBox(height: 10),
                        const DashedLine(text: 'Crear nuevo estado'),
                        const SizedBox(height: 10),
                        EstadoCard(
                          key: ValueKey(estados.length),
                          estado: EstadoFormulario(
                            nombre: 'Título',
                            color: '#000000',
                            porDefecto: false,
                          ),
                          onGuardar: (nombre, color, porDefecto) {
                            _crearEstado(
                              EstadoFormulario(
                                nombre: nombre,
                                color: colorAHex(color),
                                porDefecto: porDefecto,
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
