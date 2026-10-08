import 'package:flutter/material.dart';
import 'package:postulaciones_app/screens/inicio.dart';
import 'package:postulaciones_app/screens/login_screen.dart';
import 'package:postulaciones_app/services/api_client.dart';
import 'package:postulaciones_app/services/token_service.dart';
import 'package:postulaciones_app/theme/app_colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // 1. Aseguramos que los bindings estén listos
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

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

  ThemeData _buildTheme(AppColors c, Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      extensions: [c],
      scaffoldBackgroundColor: c.background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: c.mainColor,
        onPrimary: Colors.white,
        secondary: c.mainColor,
        onSecondary: Colors.white,
        error: c.danger,
        onError: Colors.white,
        surface: c.background,
        onSurface: c.textPrimary,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: c.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: c.textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: c.textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: c.textPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: c.textSecondary),
        labelMedium: TextStyle(
          fontWeight: FontWeight.w600,
          color: c.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: c.mainColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.mainColor,
          foregroundColor: c.background,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.mainColor,
          padding: const EdgeInsets.symmetric(vertical: 10),
          side: BorderSide(color: c.mainColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(AppColors.light, Brightness.light),
      darkTheme: _buildTheme(AppColors.dark, Brightness.dark),
      themeMode: ThemeMode.system, // sigue el modo del celular
      home: isLoggedIn ? const Inicio() : const LoginScreen(),
    );
  }
}
