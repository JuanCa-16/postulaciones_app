import 'package:flutter/material.dart';
import 'package:postulaciones_app/constants/app_strings.dart';
import 'package:postulaciones_app/models/nota.dart';
import 'package:postulaciones_app/services/nota_service.dart';
import 'package:postulaciones_app/utils/async_handler.dart';
import 'package:postulaciones_app/widgets/dashed_line.dart';
import 'package:postulaciones_app/widgets/input_field.dart';
import 'package:postulaciones_app/widgets/loading_overlay.dart';

class Notes extends StatefulWidget {
  final Nota? nota;
  final int idPostulacion;
  final ValueChanged<Nota?> onGuardada;
  final Color? color;

  const Notes({
    super.key,
    required this.nota,
    required this.idPostulacion,
    required this.onGuardada,
    this.color,
  });

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final _formKey = GlobalKey<FormState>();
  final NotaService _notaService = NotaService();

  bool guardando = false;

  String? reclutador;
  String? salario;
  String? ubicacion;
  String? horario;
  String? tipoContrato;
  String? otros;

  @override
  void initState() {
    super.initState();

    reclutador = widget.nota?.reclutador;
    salario = widget.nota?.salario;
    ubicacion = widget.nota?.ubicacion;
    horario = widget.nota?.horario;
    tipoContrato = widget.nota?.tipoContrato;
    otros = widget.nota?.otros;
  }

  String? _limpiar(String? valor, {bool multilinea = false}) {
    if (valor == null) return null;

    String texto = valor.trim();

    if (multilinea) {
      texto = texto
          .replaceAll(RegExp(r'\r\n?'), '\n')
          .split('\n')
          .map((linea) => linea.trim())
          .join('\n')
          .replaceAll(RegExp(r'\n{2,}'), '\n')
          .trim();
    }

    return texto.isEmpty ? null : texto;
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    final notaFormulario = Nota(
      reclutador: _limpiar(reclutador),
      salario: _limpiar(salario),
      ubicacion: _limpiar(ubicacion),
      horario: _limpiar(horario),
      tipoContrato: _limpiar(tipoContrato),
      otros: _limpiar(otros, multilinea: true),
    );

    await AsyncHandler.ejecutar(
      context,
      tituloError: AppStrings.errorGuardar,
      onLoading: (valor) {
        if (mounted) setState(() => guardando = valor);
      },
      accion: () async {
        final guardada = await _notaService.guardarNota(
          widget.idPostulacion,
          notaFormulario,
        );

        if (!mounted) return;

        widget.onGuardada(guardada); // el padre actualiza su nota
        Navigator.pop(context); // cierra el sheet
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      loading: guardando,
      color: widget.color,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        label: AppStrings.reclutador,
                        initialValue: widget.nota?.reclutador,
                        keyboardType: TextInputType.text,
                        icon: Icons.person_outline_rounded,
                        onSaved: (v) => reclutador = v,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: InputField(
                        label: AppStrings.salario,
                        initialValue: widget.nota?.salario,
                        keyboardType: TextInputType.text,
                        icon: Icons.attach_money_rounded,
                        onSaved: (v) => salario = v,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        label: AppStrings.ubicacion,
                        initialValue: widget.nota?.ubicacion,
                        keyboardType: TextInputType.text,
                        icon: Icons.place_outlined,
                        onSaved: (v) => ubicacion = v,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: InputField(
                        label: AppStrings.horario,
                        initialValue: widget.nota?.horario,
                        keyboardType: TextInputType.text,
                        icon: Icons.schedule,
                        onSaved: (v) => horario = v,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                InputField(
                  label: AppStrings.contrato,
                  initialValue: widget.nota?.tipoContrato,
                  keyboardType: TextInputType.text,
                  icon: Icons.description_outlined,
                  onSaved: (v) => tipoContrato = v,
                ),

                const SizedBox(height: 15),

                InputField(
                  label: AppStrings.otros,
                  initialValue: widget.nota?.otros,
                  keyboardType: TextInputType.multiline,
                  minLines: 4,
                  maxLines: 8,
                  onSaved: (v) => otros = v,
                ),

                const SizedBox(height: 15),

                const DashedLine(),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: widget.color != null
                          ? WidgetStatePropertyAll(widget.color)
                          : null,
                    ),
                    onPressed: guardando ? null : _guardar,
                    child: const Text(AppStrings.guardar),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
