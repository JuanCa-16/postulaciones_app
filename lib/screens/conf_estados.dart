import 'package:flutter/material.dart';
import 'package:postulaciones_app/constants/app_strings.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:postulaciones_app/layouts/card_layout.dart';
import 'package:postulaciones_app/models/estado.dart';
import 'package:postulaciones_app/services/estado_service.dart';
import 'package:postulaciones_app/widgets/dashed_line.dart';
import 'package:postulaciones_app/widgets/estado_card.dart';
import 'package:postulaciones_app/utils/async_handler.dart';
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

  Future<void> _editarEstado(int id, EstadoFormulario estado) async {
    await AsyncHandler.ejecutar(
      context,
      tituloError: AppStrings.errorEditar,
      onLoading: (cargando) => setState(() => this.cargando = cargando),
      accion: () async {
        await _estadoService.editarEstado(id, estado);

        if (!mounted) return;
        await _cargarEstados();
      },
    );
  }

  Future<void> _crearEstado(EstadoFormulario estado) async {
    await AsyncHandler.ejecutar(
      context,
      tituloError: AppStrings.errorCrear,
      onLoading: (cargando) => setState(() => this.cargando = cargando),
      accion: () async {
        await _estadoService.crearEstado(estado);

        if (!mounted) return;
        await _cargarEstados();
      },
    );
  }

  Future<void> _eliminarEstado(int id) async {
    await AsyncHandler.ejecutar(
      context,
      tituloError: AppStrings.errorEliminar,
      onLoading: (cargando) => setState(() => this.cargando = cargando),
      accion: () async {
        await _estadoService.eliminarEstado(id);

        if (!mounted) return;
        await _cargarEstados();
      },
    );
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
        body: CardLayout(
          title: AppStrings.configuracionEstados,
          description: AppStrings.descripcionEstados,
          child: _contenido(),
        ),
      ),
    );
  }

  Widget _contenido() {
    if (estados.isEmpty && cargando) {
      return const SizedBox(height: 120);
    }
    return SlidableAutoCloseBehavior(
      child: Column(
        children: [
          if (estados.length >= 5) ...[
            const DashedLine(text: AppStrings.maximoEstados),
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
            const DashedLine(text: AppStrings.nuevoEstado),
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
    );
  }
}
