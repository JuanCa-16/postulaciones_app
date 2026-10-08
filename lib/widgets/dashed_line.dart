import 'package:flutter/material.dart';
import 'package:postulaciones_app/theme/app_colors.dart';

class DashedLine extends StatelessWidget {
  final String? text; // Parámetro opcional para el texto en el medio

  const DashedLine({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    final color = context.colors.textSecondary;
    if (text == null || text!.isEmpty) {
      return CustomPaint(
        size: const Size(double.infinity, 1),
        painter: _DashedLinePainter(color),
      );
    }

    return Row(
      children: [
        Expanded(
          child: CustomPaint(
            size: Size(double.infinity, 1),
            painter: _DashedLinePainter(color),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            text!,
            style: TextStyle(
              color: context.colors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        Expanded(
          child: CustomPaint(
            size: Size(double.infinity, 1),
            painter: _DashedLinePainter(color),
          ),
        ),
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  _DashedLinePainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
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
