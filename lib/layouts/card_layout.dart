import 'package:flutter/material.dart';
import 'package:postulaciones_app/layouts/background.dart';


class CardLayout extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;

  const CardLayout({
    super.key,
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Background(
      statusColor: Colors.deepPurple,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            width: MediaQuery.sizeOf(context).width * 0.9,
            constraints: const BoxConstraints(
              maxWidth: 500, //En pantallas grandes un Max
            ),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 255, 255, 0.75),
              border: Border.all(
                color: const Color.fromRGBO(255, 255, 255, 0.6),
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.07),
                  blurRadius: 40,
                  offset: Offset(0, 20),
                ),
                BoxShadow(
                  color: Color.fromRGBO(255, 255, 255, 0.356),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: Offset.zero,
                ),
              ],
            ),
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
