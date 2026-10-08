import 'dart:ui';

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
        child,
        if (loading)
          variant
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: color != null
                          ? color!.withValues(alpha: 0.15)
                          : context.colors.mainColor.withValues(alpha: 0.15),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 6.0,
                          color: color ?? context.colors.mainColor,
                        ),
                      ),
                    ),
                  ),
                )
              : ClipRect(
                  // 2. ClipRect evita que el blur se desborde fuera del contenedor
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 6.0,
                        color: color ?? context.colors.mainColor,
                      ),
                    ),
                  ),
                ),
      ],
    );
  }
}
