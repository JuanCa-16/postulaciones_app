import 'package:flutter/material.dart';
import 'package:postulaciones_app/theme/app_colors.dart';

class ChipOption extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final Color? color; // por defecto mainColor
  final bool showDot; // punto de color antes del texto
  final Color? unselectedFill; // por defecto inputBackground

  const ChipOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.color,
    this.showDot = false,
    this.unselectedFill,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final base = color ?? colors.mainColor;

    final contentColor = selected ? base : colors.textSecondary;

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: base, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
          ],
          Text(label, style: TextStyle(color: contentColor)),
        ],
      ),
      selected: selected,
      showCheckmark: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: selected ? base : colors.inputFocusedBorder,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      labelPadding: const EdgeInsets.symmetric(horizontal: 2),
      color: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return base.withValues(alpha: 0.15);
        }
        return unselectedFill ?? colors.inputBackground;
      }),
      onSelected: onSelected,
    );
  }
}
