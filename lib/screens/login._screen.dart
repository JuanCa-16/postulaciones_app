import 'package:flutter/material.dart';
import 'package:postulaciones_app/layouts/card_layout.dart';
import 'package:postulaciones_app/models/user_login.dart';
import 'package:postulaciones_app/screens/inicio.dart';
import 'package:postulaciones_app/services/auth_service.dart';
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

  Future<void> _ingresar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      cargando = true;
    });

    try {
      final usuario = UserLogin(correo: correo, clave: contrasena);
      await _authService.login(usuario);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Inicio()),
      );
    } catch (e) {
      final mensaje = e.toString().replaceFirst('Exception: ', '');
      await _mostrarError(mensaje);
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  Future<void> _mostrarError(String mensaje) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error al iniciar sesión'),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Aceptar'),
            ),
          ],
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
            title: 'Inicio de Sesión',
            description: 'Ingresa tus credenciales',
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  InputField(
                    label: 'Correo *',
                    keyboardType: TextInputType.emailAddress,
                    focusNode: _correoFocus,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El correo es obligatorio';
                      }

                      if (!value.contains('@')) {
                        return 'Ingresa un correo válido';
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
                    label: 'contraseña *',
                    focusNode: _contrasenaFocus,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La contraseña es obligatoria';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      contrasena = value!;
                    },

                    onFieldSubmitted: (_) {
                      _ingresar();
                    },
                  ),

                  const SizedBox(height: 15),

                  const DashedLine(),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: cargando ? null : _ingresar,
                      child: const Text('Ingresar'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Botón Explorar Demo
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Explorar Demo'),
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
