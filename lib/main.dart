import 'package:flutter/material.dart';
import 'package:postulaciones_app/screens/inicio.dart';
import 'package:postulaciones_app/screens/login._screen.dart';
import 'package:postulaciones_app/services/api_client.dart';
import 'package:postulaciones_app/services/token_service.dart';
import 'package:postulaciones_app/theme/app_colors.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // 1. Aseguramos que los bindings estén listos
  WidgetsFlutterBinding.ensureInitialized();
  ApiClient.navigatorKey = navigatorKey;
  // 2. Consultamos el token
  final tokenService = TokenService();
  final String? token = await tokenService.obtenerToken();

  // 3. Evaluamos de forma segura (si token es null, se convierte en false)
  final bool isLoggedIn = token != null && token.isNotEmpty;

  // 4. Ejecutamos la app pasando un booleano puro que jamás será null
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          titleSmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: AppColors.textPrimary),
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
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
      home: isLoggedIn ? const Inicio() : const LoginScreen(),
    );
  }
}
