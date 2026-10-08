import 'package:flutter/material.dart';
import 'package:postulaciones_app/theme/app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;

  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: MediaQuery.sizeOf(context).width * 0.9,
      constraints: const BoxConstraints(maxWidth: 500),
      decoration: BoxDecoration(
        color: context.colors.background.withValues(alpha: 0.75),
        border: Border.all(color: context.colors.inputFocusedBorder),
        borderRadius: BorderRadius.circular(12),
        boxShadow:  [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}
