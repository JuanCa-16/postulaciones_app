import 'package:flutter/material.dart';
import 'package:postulaciones_app/constants/app_strings.dart';
import 'package:postulaciones_app/models/historial.dart';
import 'package:postulaciones_app/theme/app_colors.dart';
import 'package:postulaciones_app/widgets/glass_card.dart';
import 'package:postulaciones_app/widgets/icon_text.dart';
import 'package:postulaciones_app/widgets/label_text.dart';

class HistoryCard extends StatelessWidget {
  final Historial item;
  const HistoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.campoActualizado,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                IconText(
                  icon: Icons.calendar_month,
                  color: AppColors.textSecondary,
                  label: item.fechaFormateada,
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: LabelText(
                    label: AppStrings.antes,
                    text: item.valorAntiguo ?? AppStrings.sinDato,
                  ),
                ),

                Expanded(
                  child: SizedBox(
                    width: 40,
                    child: Center(
                      child: Text(
                        '➔',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: LabelText(
                    label: AppStrings.actual,
                    text: item.valorNuevo,
                    color: AppColors.mainColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
