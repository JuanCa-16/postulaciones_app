import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final IconData icon;
  final double? iconSize;
  final Color color;
  final String label;

  const IconText({
    super.key,
    this.iconSize,
    required this.color,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(size: iconSize ?? 18.0, color: color, icon),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: color),
        ),
      ],
    );
  }
}
