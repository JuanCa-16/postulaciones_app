import 'package:flutter/material.dart';
import 'package:postulaciones_app/theme/app_colors.dart';

class LoadingOverlay extends StatelessWidget {
  final bool loading;
  final Widget child;
  final Color? color;
  final bool variant;

  const LoadingOverlay({
    super.key,
    required this.loading,
    required this.child,
    this.color,
    this.variant = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child, // La pantalla de fondo
        if (loading)
          variant
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: color != null
                        ? color!.withValues(alpha: 0.15)
                        : AppColors.buttonPrimary.withValues(alpha: 0.15),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: color ?? AppColors.buttonPrimary,
                      ),
                    ),
                  ),
                )
              : Container(
                  color: color ?? Colors.black54,
                  child: const Center(child: CircularProgressIndicator()),
                ),
      ],
    );
  }
}
