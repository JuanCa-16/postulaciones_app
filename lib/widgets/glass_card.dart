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
        color: const Color.fromRGBO(255, 255, 255, 0.75),
        border: Border.all(color: AppColors.inputFocusedBorder),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.07),
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
          BoxShadow(
            color: Color.fromRGBO(255, 255, 255, 0.356),
            blurRadius: 20,
            offset: Offset.zero,
          ),
        ],
      ),
      child: child,
    );
  }
}
