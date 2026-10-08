import 'package:flutter/material.dart';
import 'package:postulaciones_app/theme/app_colors.dart';

class ChipRadio extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;

  const ChipRadio({
    super.key,
    required this.label,
    required this.color,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? color : Colors.transparent,
        border: Border.all(
          color: selected ? color : context.colors.inputFocusedBorder,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: selected ? context.colors.background : color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected ? context.colors.background : context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
