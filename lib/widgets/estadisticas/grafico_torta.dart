import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:postulaciones_app/models/estadistica.dart';
import 'package:postulaciones_app/theme/app_colors.dart';

class GraficoTorta extends StatefulWidget {
  final List<EstadisticaEstado> estadisticas;

  const GraficoTorta({super.key, required this.estadisticas});

  @override
  State<GraficoTorta> createState() => _GraficoTortaState();
}

class _GraficoTortaState extends State<GraficoTorta> {
  int indiceSeleccionado = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.estadisticas.isEmpty) {
      return const Center(child: Text('No hay estadísticas disponibles'));
    }

    if (indiceSeleccionado >= widget.estadisticas.length) {
      indiceSeleccionado = 0;
    }

    final colors = context.colors;

    return Column(
      children: [
        SizedBox(
          height: 230,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const SizedBox(height: 24),
              PieChart(
                PieChartData(
                  centerSpaceRadius: 75,
                  sectionsSpace: 2,

                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      final indice =
                          response?.touchedSection?.touchedSectionIndex;

                      // Ignora salidas del puntero y toques fuera de un segmento
                      if (!event.isInterestedForInteractions ||
                          indice == null ||
                          indice < 0) {
                        return;
                      }

                      if (indice != indiceSeleccionado) {
                        setState(() => indiceSeleccionado = indice);
                      }
                    },
                  ),

                  sections: List.generate(widget.estadisticas.length, (index) {
                    final estado = widget.estadisticas[index];
                    final seleccionado = index == indiceSeleccionado;

                    return PieChartSectionData(
                      value: estado.cantidad.toDouble(),
                      color: estado.colorParsed,
                      radius: seleccionado ? 40 : 38,
                      cornerRadius: 8,
                      showTitle: false,
                    );
                  }),
                ),
              ),

              // Información central del segmento seleccionado
              if (indiceSeleccionado >= 0 &&
                  indiceSeleccionado < widget.estadisticas.length)
                _informacionCentral(widget.estadisticas[indiceSeleccionado]),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Leyenda
        // Leyenda interactiva
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 10,
          children: List.generate(widget.estadisticas.length, (index) {
            final estado = widget.estadisticas[index];
            final seleccionado = index == indiceSeleccionado;

            return GestureDetector(
              onTap: () {
                setState(() {
                  // Al tocar la leyenda, cambiamos el índice seleccionado
                  indiceSeleccionado = index;
                });
              },
              child: Container(
                // Añadimos un padding opcional para que sea más fácil de presionar (área táctil)
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  // Opcional: puedes darle un fondito sutil si está seleccionado
                  color: seleccionado
                      ? estado.colorParsed.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: estado.colorParsed,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      estado.nombre,
                      style: TextStyle(
                        // Opcional: puedes resaltar el texto del seleccionado
                        color: seleccionado
                            ? estado.colorParsed
                            : colors.textPrimary,
                        fontWeight: seleccionado
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _informacionCentral(EstadisticaEstado estado) {
    final colorEstado = estado.colorParsed;

    return IgnorePointer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(estado.nombre, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 5),
          Text(
            '${estado.cantidad}',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: colorEstado,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '${estado.porcentaje.toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
