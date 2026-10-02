import 'package:flutter/material.dart';
import 'package:postulaciones_app/models/estado.dart';
import 'package:postulaciones_app/models/postulacion.dart';
import 'package:postulaciones_app/screens/postulacion_form.dart';

class EditarPostulacion extends StatelessWidget {
  final Postulacion postulacion;
  const EditarPostulacion({super.key, required this.postulacion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PostulacionForm(
        color: postulacion.estado.colorParsed,
        datosIniciales: postulacion.datosParaFormulario,
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
        onSubmit: (postulacion) {
          debugPrint('💯' + postulacion.toString());
        },
      ),
    );
  }
}
