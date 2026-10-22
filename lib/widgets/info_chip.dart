import 'package:flutter/material.dart';
import 'package:postulaciones_app/widgets/icon_text.dart';

class InfoChip extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final double? iconSize;

  const InfoChip({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
    this.iconSize,
  });

  @override
  State<InfoChip> createState() => _InfoChipState();
}

class _InfoChipState extends State<InfoChip> {
  bool presionado = false;

  void _setPresionado(bool valor) {
    if (widget.onTap == null) return; // sin onTap no anima
    setState(() => presionado = valor);
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(8);

    return AnimatedScale(
      scale: presionado ? 0.92 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Material(
        color: widget.color.withValues(alpha: 0.05),
        borderRadius: radius,
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: (_) => _setPresionado(true),
          onTapUp: (_) => _setPresionado(false),
          onTapCancel: () => _setPresionado(false),
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: IconText(
              icon: widget.icon,
              color: widget.color,
              label: widget.label,
              iconSize: widget.iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
