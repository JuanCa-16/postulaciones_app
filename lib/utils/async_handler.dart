import 'package:flutter/material.dart';
import 'package:postulaciones_app/widgets/dialog_helper.dart';

class AsyncHandler {
  static Future<void> ejecutar(
    BuildContext context, {
    String tituloError = 'Error en la Operación',
    required Function(bool) onLoading,
    required Future<void> Function() accion,
  }) async {
    onLoading(true);
    try {
      await accion();
    } catch (e) {
      if (!context.mounted) return;
      final mensaje = e.toString().replaceFirst('Exception: ', '');
      await DialogHelper.mostrarError(context, mensaje, titulo: tituloError);
    } finally {
      if (context.mounted) {
        onLoading(false);
      }
    }
  }
}
