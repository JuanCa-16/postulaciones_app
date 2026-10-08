import 'package:flutter/material.dart';
import 'package:postulaciones_app/layouts/background.dart';
import 'package:postulaciones_app/theme/app_colors.dart';
import 'package:postulaciones_app/widgets/glass_card.dart';

class CardLayout extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;
  final Color? color;

  const CardLayout({
    super.key,
    required this.title,
    required this.description,
    required this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Background(
      statusColor: color ?? AppColors.mainColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 24),

                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
