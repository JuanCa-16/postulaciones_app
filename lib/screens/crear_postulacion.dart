import 'package:flutter/material.dart';
import 'package:postulaciones_app/constants/app_strings.dart';
import 'package:postulaciones_app/models/estado.dart';
import 'package:postulaciones_app/models/postulacion.dart';
import 'package:postulaciones_app/screens/postulacion_form.dart';
import 'package:postulaciones_app/services/estado_service.dart';
import 'package:postulaciones_app/services/postulacion_service.dart';
import 'package:postulaciones_app/utils/async_handler.dart';
import 'package:postulaciones_app/widgets/loading_overlay.dart';

class CrearPostulacion extends StatefulWidget {
  const CrearPostulacion({super.key});

  @override
  State<CrearPostulacion> createState() => _CrearPostulacionState();
}

class _CrearPostulacionState extends State<CrearPostulacion> {
  final PostulacionService _postulacionService = PostulacionService();
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

  Future<void> _crearPostulacion(PostulacionFormulario postulacion) async {
    await AsyncHandler.ejecutar(
      context,
      tituloError: AppStrings.errorCrear,
      onLoading: (cargando) => setState(() => this.cargando = cargando),
      accion: () async {
        await _postulacionService.crearPostulacion(postulacion);

        if (!mounted) return;
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      loading: cargando,
      variant: true,
      child: Scaffold(
        body: PostulacionForm(
          datosIniciales: null,
          estados: estados,
          onSubmit: _crearPostulacion,
        ),
      ),
    );
  }
}
