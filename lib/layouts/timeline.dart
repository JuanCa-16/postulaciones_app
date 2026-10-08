import 'package:flutter/material.dart';
import 'package:postulaciones_app/models/historial.dart';
import 'package:postulaciones_app/theme/app_colors.dart';
import 'package:postulaciones_app/widgets/history_card.dart';

class Timeline extends StatelessWidget {
  final List<Historial> historialList;
  final Color color;
  const Timeline({super.key, required this.color, required this.historialList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10, bottom: 40, right: 10),
      itemCount: historialList.length,
      itemBuilder: (context, index) {
        final item = historialList[index];

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 24,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 2,
                        color: context.colors.inputFocusedBorder,
                      ),
                    ),

                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),

                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Expanded(child: HistoryCard(item: item)),
            ],
          ),
        );
      },
    );
  }
}
