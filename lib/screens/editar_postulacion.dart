import 'package:flutter/material.dart';
import 'package:postulaciones_app/models/estado.dart';
import 'package:postulaciones_app/models/postulacion.dart';
import 'package:postulaciones_app/screens/postulacion_form.dart';
import 'package:postulaciones_app/services/estado_service.dart';
import 'package:postulaciones_app/services/postulacion_service.dart';
import 'package:postulaciones_app/widgets/dialog_helper.dart';
import 'package:postulaciones_app/widgets/loading_overlay.dart';

class EditarPostulacion extends StatefulWidget {
  final Postulacion postulacion;
  const EditarPostulacion({super.key, required this.postulacion});

  @override
  State<EditarPostulacion> createState() => _EditarPostulacionState();
}

class _EditarPostulacionState extends State<EditarPostulacion> {
  final PostulacionService _postulacionService = PostulacionService();
  bool cargando = false;
  final EstadoService _estadoService = EstadoService();
  List<Estado> estados = [];

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

  Future<void> _editarPostulacion(PostulacionFormulario postulacion) async {
    setState(() {
      cargando = true;
    });

    try {
      final resultado = await _postulacionService.editarPostulacion(
        widget.postulacion.id,
        postulacion,
      );

      if (!mounted) return;
      debugPrint(resultado.toString());
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      final mensaje = e.toString().replaceFirst('Exception: ', '');

      await DialogHelper.mostrarError(
        context,
        mensaje,
        titulo: 'Error al editar postulación',
      );
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      loading: cargando,
      variant: true,
      color: widget.postulacion.estado.colorParsed,
      child: Scaffold(
        body: estados.isEmpty
            ? const SizedBox.shrink()
            : PostulacionForm(
                color: widget.postulacion.estado.colorParsed,
                datosIniciales: widget.postulacion.datosParaFormulario,
                estados: estados,
                onSubmit: _editarPostulacion,
              ),
      ),
    );
  }
}
