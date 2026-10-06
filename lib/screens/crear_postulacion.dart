import 'package:flutter/material.dart';
import 'package:postulaciones_app/models/estado.dart';
import 'package:postulaciones_app/models/postulacion.dart';
import 'package:postulaciones_app/screens/postulacion_form.dart';
import 'package:postulaciones_app/services/estado_service.dart';
import 'package:postulaciones_app/services/postulacion_service.dart';
import 'package:postulaciones_app/widgets/dialog_helper.dart';
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

  Future<void> _crearPostulacion(PostulacionFormulario postulacion) async {
    setState(() {
      cargando = true;
    });

    try {
      final resultado = await _postulacionService.crearPostulacion(postulacion);

      if (!mounted) return;
      debugPrint(resultado.toString());
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      final mensaje = e.toString().replaceFirst('Exception: ', '');

      await DialogHelper.mostrarError(
        context,
        mensaje,
        titulo: 'Error al crear postulación',
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
      child: Scaffold(
        body: estados.isEmpty
            ? const SizedBox.shrink()
            : PostulacionForm(
                datosIniciales: null,
                estados: estados,
                onSubmit: _crearPostulacion,
              ),
      ),
    );
  }
}
