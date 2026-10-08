import 'package:flutter/material.dart';
import 'package:postulaciones_app/theme/app_colors.dart';

class LabelText extends StatelessWidget {
  final String label;
  final String text;
  final bool hightlight;
  final bool urlFormat;
  final Color? color;
  final VoidCallback? onTap;

  const LabelText({
    super.key,
    required this.label,
    required this.text,
    this.hightlight = false,
    this.urlFormat = false,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelMedium,
        ),
        SizedBox(height: 4),
        hightlight
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.inputFocusedBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
              )
            : urlFormat
            ? Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: color ?? AppColors.mainColor,
                    ),
                  ),
                ),
              )
            : Text(
                text,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: color),
              ),
      ],
    );
  }
}
