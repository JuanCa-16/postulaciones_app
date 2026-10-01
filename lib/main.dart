import 'package:flutter/material.dart';
import 'package:postulaciones_app/screens/crear_postulacion.dart';
import 'package:postulaciones_app/screens/editar_postulacion.dart';
import 'package:postulaciones_app/screens/postulacion_form.dart';
import 'package:postulaciones_app/theme/app_colors.dart';
import 'package:postulaciones_app/layouts/background.dart';
import 'package:postulaciones_app/screens/login._screen.dart';
import 'package:postulaciones_app/widgets/chip_radio.dart';
import 'package:postulaciones_app/widgets/input_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          bodyMedium: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          labelMedium: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonPrimary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.buttonSecondary,
            padding: const EdgeInsets.symmetric(vertical: 10),
            side: const BorderSide(color: AppColors.buttonSecondary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: Scaffold(
        body: Background(
          statusColor: const Color.fromARGB(255, 76, 42, 249),
          child: CrearPostulacion(),
          // child: const Padding(
          //   padding: EdgeInsets.all(16),
          //   child: Column(
          //     children: [
          //       InputField(label: 'Correo'),
          //       ChipRadio(label: 'Opcion', color: Colors.deepOrangeAccent),
          //       ChipRadio(
          //         label: 'Opcion',
          //         color: Colors.deepOrangeAccent,
          //         selected: true,
          //       ),
          //       ChipRadio(label: 'Opc2', color: Colors.purple),
          //       ChipRadio(label: 'Opc2', color: Colors.purple, selected: true),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}
