import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:postulaciones_app/theme/app_colors.dart';

class Background extends StatelessWidget {
  final Color statusColor;
  final Widget child;
  const Background({super.key, required this.statusColor, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: LayoutBuilder(
        builder: (context, constrains) {
          final sphereSize = (constrains.maxWidth * 0.33)
              .clamp(300.0, double.infinity)
              .toDouble();

          return Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              //FONDO BASE
              const ColoredBox(color: AppColors.background),

              //ESFERA SUPERIOR IZQ
              Positioned(top: -15, left: -15, child: _buildSphere(sphereSize)),

              //ESFERA INFERIOR DER
              Positioned(
                bottom: -15,
                right: -15,
                child: _buildSphere(sphereSize),
              ),

              //  FONDO TRANSAPARENTE Y DESENFOQUE
              Positioned.fill(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(color: AppColors.backgroundTransparent),
                  ),
                ),
              ),

              //CONTENIDO
              Center(child: SafeArea(child: child)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSphere(double size) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 150, sigmaY: 150),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
      ),
    );
  }
}
