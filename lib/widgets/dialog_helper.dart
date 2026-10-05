import 'package:flutter/material.dart';

class DialogHelper {
  static Future<void> mostrarError(
    BuildContext context,
    String mensaje, {
    String titulo = 'Ha ocurrido un error',
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
