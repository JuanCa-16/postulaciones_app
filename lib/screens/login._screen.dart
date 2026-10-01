import 'package:flutter/material.dart';
import 'package:postulaciones_app/layouts/card_layout.dart';
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

  Future<void> _ingresar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      cargando = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      cargando = false;
    });

    debugPrint('💯Correo: $correo');
    debugPrint('💯Contraseña: $contrasena');
  }

  @override
  void dispose() {
    _correoFocus.dispose();
    _contrasenaFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CardLayout(
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
        LoadingOverlay(loading: cargando),
      ],
    );
  }
}
