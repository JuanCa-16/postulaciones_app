import 'package:flutter/material.dart';
import 'package:postulaciones_app/models/estadistica.dart';
import 'package:postulaciones_app/theme/app_colors.dart';
import 'package:postulaciones_app/widgets/dashed_line.dart';
import 'package:postulaciones_app/widgets/utils/contador_animado.dart';

const _duracion = Duration(milliseconds: 800);
const _curva = Curves.easeOutCubic;

class GraficoModalidades extends StatelessWidget {
  final List<EstadisticaModalidad> estadisticas;
  final int total;

  const GraficoModalidades({
    super.key,
    required this.estadisticas,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------- HEADER ----------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              'TOTAL POSTULACIONES',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: colors.textPrimary,
              ),
            ),
            ContadorAnimado(
              duracion: _duracion,
              curva: _curva,
              valor: total,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: colors.mainColor,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        DashedLine(),
        const SizedBox(height: 20),

        // ---------- BARRAS ----------
        for (final mod in estadisticas) ...[
          _BarraModalidad(
            nombre: mod.modalidad.nombreModalidad,
            cantidad: mod.cantidad,
            porcentaje: mod.porcentaje,
            color: colors.mainColor,
          ),
          const SizedBox(height: 14),
        ],
      ],
    );
  }
}

class _BarraModalidad extends StatelessWidget {
  final String nombre;
  final int cantidad;
  final double porcentaje; // 0 a 100
  final Color color;

  const _BarraModalidad({
    required this.nombre,
    required this.cantidad,
    required this.porcentaje,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              nombre,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colors.textPrimary,
              ),
            ),
            ContadorAnimado(
              duracion: _duracion,
              curva: _curva,
              valor: cantidad,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 8,
            child: Stack(
              children: [
                // Fondo de la barra
                Positioned.fill(
                  child: ColoredBox(
                    color: colors.mainColor.withValues(alpha: 0.15),
                  ),
                ),
                // Relleno animado de 0 al porcentaje
                TweenAnimationBuilder<double>(
                  tween: Tween(
                    begin: 0,
                    end: (porcentaje / 100).clamp(0.0, 1.0),
                  ),
                  duration: _duracion,
                  curve: _curva,
                  builder: (context, valor, _) => Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: valor,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
