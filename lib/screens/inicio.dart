import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:postulaciones_app/models/postulacion.dart';
import 'package:postulaciones_app/widgets/postulacion_card.dart';
import 'package:postulaciones_app/screens/detalles_postulacion.dart';

class Inicio extends StatefulWidget {
  final List<Postulacion> postulaciones;
  const Inicio({super.key, required this.postulaciones});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int? postulacionExpandida;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SlidableAutoCloseBehavior(
        closeWhenOpened: true,
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: widget.postulaciones.map((postulacion) {
            return PostulacionCard(
              key: ValueKey(postulacion.id),
              postulacion: postulacion,
              expandido: postulacionExpandida == postulacion.id,
              onTap: () {
                setState(() {
                  postulacionExpandida = postulacionExpandida == postulacion.id
                      ? null
                      : postulacion.id;
                });
              },
              onEditar: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetallesPostulacion(postulacion: postulacion),
                  ),
                );
              },
              onEliminar: () {
                // Lógica de eliminar
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
