import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final IconData icon;
  final double? iconSize;
  final Color color;
  final String label;
  final bool? defaultStyle;

  const IconText({
    super.key,
    this.iconSize,
    required this.color,
    required this.label,
    required this.icon,
    this.defaultStyle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(size: iconSize ?? 18.0, color: color, icon),
        const SizedBox(width: 6),
        Text(
          label,
          style: defaultStyle == true
              ? Theme.of(context).textTheme.bodyLarge?.copyWith(color: color)
              : Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
        ),
      ],
    );
  }
}
