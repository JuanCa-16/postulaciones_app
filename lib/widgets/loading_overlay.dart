import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool loading;
  final Widget child; // El contenido de tu pantalla (Scaffold, etc.)

  const LoadingOverlay({super.key, required this.loading, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child, // La pantalla de fondo
        if (loading)
          Container(
            color: Colors.black54,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
