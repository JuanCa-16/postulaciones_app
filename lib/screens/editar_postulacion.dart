import 'package:flutter/material.dart';
import 'package:postulaciones_app/models/estado.dart';
import 'package:postulaciones_app/models/postulacion.dart';
import 'package:postulaciones_app/screens/postulacion_form.dart';
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
        body: PostulacionForm(
          color: widget.postulacion.estado.colorParsed,
          datosIniciales: widget.postulacion.datosParaFormulario,
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
              nombre: 'Rechazado',
              color: '#EF4444',
              porDefecto: false,
            ),
            Estado(
              id: 4,
              nombre: 'Aceptado',
              color: '#10B981',
              porDefecto: false,
            ),
            Estado(
              id: 5,
              nombre: 'HV Vista',
              color: '#b93de6',
              porDefecto: false,
            ),
          ],
          onSubmit: _editarPostulacion,
        ),
      ),
    );
  }
}
