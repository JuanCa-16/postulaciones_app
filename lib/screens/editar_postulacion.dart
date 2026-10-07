import 'package:flutter/material.dart';
import 'package:postulaciones_app/constants/app_strings.dart';
import 'package:postulaciones_app/models/estado.dart';
import 'package:postulaciones_app/models/postulacion.dart';
import 'package:postulaciones_app/screens/postulacion_form.dart';
import 'package:postulaciones_app/services/estado_service.dart';
import 'package:postulaciones_app/services/postulacion_service.dart';
import 'package:postulaciones_app/utils/async_handler.dart';
import 'package:postulaciones_app/widgets/loading_overlay.dart';

class EditarPostulacion extends StatefulWidget {
  final Postulacion postulacion;
  const EditarPostulacion({super.key, required this.postulacion});

  @override
  State<EditarPostulacion> createState() => _EditarPostulacionState();
}

class _EditarPostulacionState extends State<EditarPostulacion> {
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

  Future<void> _editarPostulacion(PostulacionFormulario postulacion) async {
    await AsyncHandler.ejecutar(
      context,
      tituloError: AppStrings.errorEditar,
      onLoading: (cargando) => setState(() => this.cargando = cargando),
      accion: () async {
        final resultado = await _postulacionService.editarPostulacion(
          widget.postulacion.id,
          postulacion,
        );

        if (!mounted) return;
        debugPrint(resultado.toString());
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      loading: cargando,
      variant: true,
      color: widget.postulacion.estado.colorParsed,
      child: Scaffold(
        body: PostulacionForm(
          color: widget.postulacion.estado.colorParsed,
          datosIniciales: widget.postulacion.datosParaFormulario,
          estados: estados,
          onSubmit: _editarPostulacion,
        ),
      ),
    );
  }
}
