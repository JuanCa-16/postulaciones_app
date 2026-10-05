import 'package:flutter/material.dart';
import 'package:postulaciones_app/models/estado.dart';
import 'package:postulaciones_app/models/postulacion.dart';
import 'package:postulaciones_app/screens/postulacion_form.dart';
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

  bool cargando = false;

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
        body: PostulacionForm(
          datosIniciales: null,
          estados: const [
            Estado(id: 1, nombre: 'Aplicado', color: '#3B82F6', porDefecto: true),
            Estado(
              id: 2,
              nombre: 'En proceso',
              color: '#F59E0B',
              porDefecto: false,
            ),
            Estado(
              id: 3,
              nombre: 'Hv Vista',
              color: '#8B5CF6',
              porDefecto: false,
            ),
            Estado(
              id: 4,
              nombre: 'Rechazado',
              color: '#EF4444',
              porDefecto: false,
            ),
          ],
          onSubmit: _crearPostulacion,
        ),
      ),
    );
  }
}
