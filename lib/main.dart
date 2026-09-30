import 'package:flutter/material.dart';
import 'package:postulaciones_app/widgets/input_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Postulaciones')),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              InputField(label: 'Correo'),
              InputField(label: 'Nombre'),
              InputField(label: 'Contrasena'),
            ],
          ),
        ),
      ),
    );
  }
}
