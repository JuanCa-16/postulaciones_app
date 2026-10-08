import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:postulaciones_app/theme/app_colors.dart';

class BackgroundTop extends StatelessWidget {
  final Color statusColor;
  final Widget child;

  const BackgroundTop({
    super.key,
    required this.statusColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          // FONDO BASE
          const ColoredBox(color: AppColors.background),

          // RECTÁNGULO SUPERIOR
          Align(
            alignment: Alignment.topCenter,
            child: FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 0.3,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 350),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                  child: Container(color: statusColor.withValues(alpha: 0.5)),
                ),
              ),
            ),
          ),

          // FONDO TRANSPARENTE Y DESENFOQUE
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 00),
                child: Container(color: AppColors.backgroundTransparent),
              ),
            ),
          ),

          // CONTENIDO
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(child: child),
          ),
        ],
      ),
    );
  }
}
