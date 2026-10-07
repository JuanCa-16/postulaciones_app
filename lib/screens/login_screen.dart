import 'package:flutter/material.dart';
import 'package:postulaciones_app/constants/app_strings.dart';
import 'package:postulaciones_app/layouts/card_layout.dart';
import 'package:postulaciones_app/models/user_login.dart';
import 'package:postulaciones_app/screens/inicio.dart';
import 'package:postulaciones_app/services/auth_service.dart';
import 'package:postulaciones_app/utils/async_handler.dart';
import 'package:postulaciones_app/widgets/dashed_line.dart';
import 'package:postulaciones_app/widgets/input_field.dart';
import 'package:postulaciones_app/widgets/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _correoFocus = FocusNode();
  final _contrasenaFocus = FocusNode();

  String correo = '';
  String contrasena = '';
  bool cargando = false;

  final AuthService _authService = AuthService();

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    await AsyncHandler.ejecutar(
      context,
      tituloError: AppStrings.errorInicioSesion,
      onLoading: (cargando) => setState(() => this.cargando = cargando),
      accion: () async {
        final usuario = UserLogin(correo: correo, clave: contrasena);
        await _authService.login(usuario);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Inicio()),
        );
      },
    );
  }

  @override
  void dispose() {
    _correoFocus.dispose();
    _contrasenaFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LoadingOverlay(
          loading: cargando,
          child: CardLayout(
            title: AppStrings.loginTitle,
            description: AppStrings.loginDescription,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  InputField(
                    label: AppStrings.labelCorreo,
                    keyboardType: TextInputType.emailAddress,
                    focusNode: _correoFocus,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.valCorreoRequerido;
                      }

                      if (!value.contains('@')) {
                        return AppStrings.valCorreoInvalido;
                      }

                      return null;
                    },
                    onSaved: (value) {
                      correo = value!;
                    },
                    onFieldSubmitted: (_) {
                      _contrasenaFocus.requestFocus();
                    },
                  ),

                  const SizedBox(height: 15),

                  InputField(
                    label: AppStrings.labelContrasena,
                    focusNode: _contrasenaFocus,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.valContrasenaRequerida;
                      }

                      return null;
                    },
                    onSaved: (value) {
                      contrasena = value!;
                    },
                    onFieldSubmitted: (_) {
                      _iniciarSesion();
                    },
                  ),

                  const SizedBox(height: 15),

                  const DashedLine(),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: cargando ? null : _iniciarSesion,
                      child: const Text(AppStrings.ingresar),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Botón Explorar Demo
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text(AppStrings.explorarDemo),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
