import 'package:flutter/material.dart';
import 'package:postulaciones_app/theme/app_colors.dart';

class DashedLine extends StatelessWidget {
  final String? text; // Parámetro opcional para el texto en el medio

  const DashedLine({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    // Si no hay texto, mantenemos tu comportamiento original de línea completa
    if (text == null || text!.isEmpty) {
      return CustomPaint(
        size: const Size(double.infinity, 1),
        painter: _DashedLinePainter(),
      );
    }

    // Si hay texto, usamos una Row para poner línea - texto - línea
    return Row(
      children: [
        // Línea izquierda (ocupa el espacio disponible)
        Expanded(
          child: CustomPaint(
            size: Size(double.infinity, 1),
            painter: _DashedLinePainter(),
          ),
        ),

        // Texto en el centro con un pequeño padding a los lados
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            text!,
            style: const TextStyle(
              color: AppColors.textSecondary, 
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Línea derecha (ocupa el espacio disponible)
        Expanded(
          child: CustomPaint(
            size: Size(double.infinity, 1),
            painter: _DashedLinePainter(),
          ),
        ),
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textSecondary
      ..strokeWidth = 1;

    const dashWidth = 5.0;
    const dashSpace = 4.0;

    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset((startX + dashWidth).clamp(0, size.width), 0),
        paint,
      );

      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) {
    return false;
  }
}
