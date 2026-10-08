import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:postulaciones_app/constants/app_strings.dart';
import 'package:postulaciones_app/models/modalidad.dart';
import 'package:postulaciones_app/models/postulacion.dart';
import 'package:postulaciones_app/theme/app_colors.dart';
import 'package:postulaciones_app/widgets/icon_text.dart';
import 'package:postulaciones_app/widgets/status_tag.dart';

class PostulacionCard extends StatelessWidget {
  final Postulacion postulacion;
  final bool expandido;
  final VoidCallback onTap;
  final VoidCallback? onDetalles;
  final VoidCallback? onEliminar;

  const PostulacionCard({
    super.key,
    required this.postulacion,
    required this.expandido,
    required this.onTap,
    this.onDetalles,
    this.onEliminar,
  });

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio:
            0.35, // Qué tanto ocupa el espacio de los botones al abrirse
        children: [
          // Botón redondo 1 (Ej: Editar)
          CustomSlidableAction(
            onPressed: (context) => onDetalles?.call(),
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.mainColor,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: AppColors.mainColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.manage_history_rounded,
                  color: AppColors.mainColor,
                  size: 22,
                ),
              ),
            ),
          ),
          // Botón redondo 2 (Ej: Eliminar)
          CustomSlidableAction(
            onPressed: (context) => onEliminar?.call(),
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.danger,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.delete, color: AppColors.danger, size: 22),
              ),
            ),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: postulacion.estado.colorParsed.withValues(alpha: 0.2),
              ),
            ),
            child: Stack(
              children: [
                // FONDO DIFUMINADO (Fijo ocupando toda la tarjeta)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.2,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 150, sigmaY: 200),
                        child: Container(
                          color: postulacion.estado.colorParsed.withValues(
                            alpha: 0.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // CONTENIDO CON ANIMACIÓN DE TAMAÑO
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  postulacion.nombreOferta,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                if (postulacion.nombreEmpresa != null)
                                  Text(
                                    postulacion.nombreEmpresa!,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge,
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          StatusTag(
                            label: postulacion.estado.nombre,
                            color: postulacion.estado.colorParsed,
                          ),
                        ],
                      ),

                      // AnimatedSize aplicado únicamente a la sección expandible
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: SizedBox(
                          width: double.infinity,
                          child: expandido
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: postulacion.estado.colorParsed
                                              .withValues(alpha: 0.05),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Wrap(
                                          alignment: WrapAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          spacing: 8,
                                          runSpacing: 4,
                                          children: [
                                            if (postulacion.paginaAplicacion !=
                                                null)
                                              IconText(
                                                icon: Icons.work,
                                                color: postulacion
                                                    .estado
                                                    .colorParsed,
                                                label: postulacion
                                                    .paginaAplicacion!,
                                              ),

                                            IconText(
                                              icon: switch (postulacion
                                                  .modalidad) {
                                                Modalidad.REMOTO =>
                                                  Icons.devices,
                                                Modalidad.HIBRIDO =>
                                                  Icons.apartment_rounded,
                                                Modalidad.PRESENCIAL =>
                                                  Icons.business_outlined,
                                              },
                                              color: postulacion
                                                  .estado
                                                  .colorParsed,
                                              label: _capitalize(
                                                postulacion.modalidad.valor,
                                              ),
                                            ),

                                            if (postulacion.url != null &&
                                                postulacion.url!
                                                    .trim()
                                                    .isNotEmpty)
                                              InkWell(
                                                onTap: postulacion.abrirUrl,
                                                child: IconText(
                                                  icon: Icons.link,
                                                  iconSize: 24.0,
                                                  color: postulacion
                                                      .estado
                                                      .colorParsed,
                                                  label: AppStrings.enlace,
                                                ),
                                              ),

                                            IconText(
                                              icon: Icons.calendar_month,
                                              color: postulacion
                                                  .estado
                                                  .colorParsed,
                                              label:
                                                  postulacion.fechaFormateada,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
