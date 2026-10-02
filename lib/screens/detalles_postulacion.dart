import 'package:flutter/material.dart';
import 'package:postulaciones_app/layouts/background_top.dart';
import 'package:postulaciones_app/layouts/timeline.dart';
import 'package:postulaciones_app/models/postulacion.dart';
import 'package:postulaciones_app/widgets/dashed_line.dart';
import 'package:postulaciones_app/widgets/glass_card.dart';
import 'package:postulaciones_app/widgets/label_text.dart';
import 'package:postulaciones_app/widgets/status_tag.dart';

class DetallesPostulacion extends StatelessWidget {
  final Postulacion postulacion;
  const DetallesPostulacion({super.key, required this.postulacion});

  @override
  Widget build(BuildContext context) {
    return BackgroundTop(
      statusColor: postulacion.estado.colorParsed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    postulacion.nombreOferta,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SizedBox(width: 14),
                StatusTag(
                  label: postulacion.estado.nombre,
                  color: postulacion.estado.colorParsed,
                ),
              ],
            ),
            SizedBox(height: 16),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      if (postulacion.nombreEmpresa != null &&
                          postulacion.nombreEmpresa!.trim().isNotEmpty)
                        LabelText(
                          label: 'Empresa',
                          text: postulacion.nombreEmpresa!,
                        ),

                      if (postulacion.paginaAplicacion != null &&
                          postulacion.paginaAplicacion!.trim().isNotEmpty)
                        LabelText(
                          label: 'Página aplicación',
                          text: postulacion.paginaAplicacion!,
                        ),

                      LabelText(
                        label: 'Modalidad',
                        text: postulacion.modalidad.valor,
                        hightlight: true,
                      ),

                      if (postulacion.fecha.trim().isNotEmpty)
                        LabelText(
                          label: 'Fecha postulación',
                          text: postulacion.fechaFormateada,
                        ),
                    ],
                  ),
                  if (postulacion.url != null &&
                      postulacion.url!.trim().isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const DashedLine(),
                    const SizedBox(height: 16),
                    LabelText(
                      label: 'Enlace de oferta',
                      text: postulacion.url!,
                      urlFormat: true,
                      onTap: postulacion.abrirUrl,
                      color: postulacion.estado.colorParsed
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Timeline(
                color: postulacion.estado.colorParsed,
                historialList: postulacion.historial ?? [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
