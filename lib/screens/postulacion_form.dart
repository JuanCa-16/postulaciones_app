import 'package:flutter/material.dart';
import 'package:postulaciones_app/constants/app_strings.dart';
import 'package:postulaciones_app/layouts/card_layout.dart';
import 'package:postulaciones_app/models/estado.dart';
import 'package:postulaciones_app/models/modalidad.dart';
import 'package:postulaciones_app/models/postulacion.dart';
import 'package:postulaciones_app/theme/app_colors.dart';
import 'package:postulaciones_app/widgets/dashed_line.dart';
import 'package:postulaciones_app/widgets/input_field.dart';

class PostulacionForm extends StatefulWidget {
  final PostulacionFormulario? datosIniciales;
  final List<Estado> estados;
  final Color? color;
  final Future<void> Function(PostulacionFormulario postulacion) onSubmit;

  const PostulacionForm({
    super.key,
    this.datosIniciales,
    required this.estados,
    required this.onSubmit,
    this.color,
  });

  @override
  State<PostulacionForm> createState() => _PostulacionFormState();
}

class _PostulacionFormState extends State<PostulacionForm> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _empresaFocus = FocusNode();
  final FocusNode _urlFocus = FocusNode();
  final FocusNode _paginaAplicacionFocus = FocusNode();

  Modalidad? modalidad;
  int? estadoId;
  String nombreOferta = '';
  String nombreEmpresa = '';
  String url = '';
  String paginaAplicacion = '';

  void _seleccionarEstadoInicial() {
    if (estadoId != null) return; // ya hay uno, no lo pises

    if (widget.datosIniciales != null) {
      estadoId = widget.datosIniciales!.estadoId;
    } else if (widget.estados.isNotEmpty) {
      estadoId = widget.estados
          .firstWhere(
            (estado) => estado.porDefecto,
            orElse: () => widget.estados.first,
          )
          .id;
    }
  }

  @override
  void initState() {
    super.initState();

    modalidad = widget.datosIniciales?.modalidad ?? Modalidad.REMOTO;
    _seleccionarEstadoInicial();
  }

  @override
  void didUpdateWidget(covariant PostulacionForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    _seleccionarEstadoInicial();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (estadoId == null) return;

    _formKey.currentState!.save();

    final postulacion = PostulacionFormulario(
      nombreOferta: nombreOferta.trim(),
      nombreEmpresa: nombreEmpresa.isEmpty ? null : nombreEmpresa.trim(),
      url: url.isEmpty ? null : url.trim(),
      paginaAplicacion: paginaAplicacion.isEmpty
          ? null
          : paginaAplicacion.trim(),
      modalidad: modalidad!,
      estadoId: estadoId!,
    );

    await widget.onSubmit(postulacion);
  }

  @override
  void dispose() {
    _empresaFocus.dispose();
    _urlFocus.dispose();
    _paginaAplicacionFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final datos = widget.datosIniciales;
    return CardLayout(
      color: widget.color,
      title: datos == null
          ? AppStrings.crearNuevaPostulacion
          : AppStrings.editarPostulacion,
      description: AppStrings.descripcionPostulacion,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputField(
              label: AppStrings.nombreOferta,
              placeholder: AppStrings.placeholderNombreOferta,
              initialValue: datos?.nombreOferta,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppStrings.valOfertaRequerido;
                }

                return null;
              },
              onSaved: (value) => nombreOferta = value ?? '',
              onFieldSubmitted: (_) => _empresaFocus.requestFocus(),
            ),

            const SizedBox(height: 15),

            InputField(
              label: AppStrings.empresa,
              placeholder: AppStrings.placeholderEmpresa,
              initialValue: datos?.nombreEmpresa,
              keyboardType: TextInputType.text,
              focusNode: _empresaFocus,
              onSaved: (value) => nombreEmpresa = value ?? '',
              onFieldSubmitted: (_) => _urlFocus.requestFocus(),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: InputField(
                    label: AppStrings.urlOferta,
                    placeholder: AppStrings.placeholderUrl,
                    initialValue: datos?.url,
                    keyboardType: TextInputType.url,
                    focusNode: _urlFocus,
                    onSaved: (value) => url = value ?? '',
                    onFieldSubmitted: (_) =>
                        _paginaAplicacionFocus.requestFocus(),
                  ),
                ),

                const SizedBox(width: 15),
                Expanded(
                  child: InputField(
                    label: AppStrings.pagAplicacion,
                    placeholder: AppStrings.placeholderPlataforma,
                    initialValue: datos?.paginaAplicacion,
                    keyboardType: TextInputType.text,
                    focusNode: _paginaAplicacionFocus,
                    onSaved: (value) => paginaAplicacion = value ?? '',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Text(
              '${AppStrings.modalidad}*'.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium,
            ),

            const SizedBox(height: 5),

            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 8,
                alignment: WrapAlignment.start,
                children: Modalidad.values.map((modalidadItem) {
                  return ChoiceChip(
                    label: Text(
                      nombreModalidad(modalidadItem),
                      style: TextStyle(
                        color: modalidad == modalidadItem
                            ? AppColors.buttonPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                    selected: modalidad == modalidadItem,
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: modalidad == modalidadItem
                            ? AppColors.buttonPrimary
                            : AppColors.inputFocusedBorder,
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                    color: WidgetStateColor.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColors.buttonPrimary.withValues(alpha: 0.15);
                      }

                      return AppColors.inputBackground;
                    }),

                    onSelected: (_) =>
                        setState(() => modalidad = modalidadItem),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 15),

            Text(
              AppStrings.estadoActual.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium,
            ),

            const SizedBox(height: 5),

            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 8,
                alignment: WrapAlignment.start,
                children: widget.estados.map((estado) {
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: estadoId == estado.id
                                ? Colors.white
                                : estado.colorParsed,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          estado.nombre,
                          style: TextStyle(
                            color: estadoId == estado.id
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    selected: estadoId == estado.id,
                    showCheckmark: false,
                    color: WidgetStateColor.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return estado.colorParsed;
                      }

                      return AppColors.inputBackground;
                    }),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: estadoId == estado.id
                            ? estado.colorParsed
                            : AppColors.inputFocusedBorder,
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                    onSelected: (_) => setState(() => estadoId = estado.id),
                  );
                }).toList(),
              ),
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
                onPressed: _guardar,
                child: Text(
                  datos == null ? AppStrings.crear : AppStrings.guardar,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String nombreModalidad(Modalidad modalidad) {
  switch (modalidad) {
    case Modalidad.REMOTO:
      return AppStrings.remoto;
    case Modalidad.HIBRIDO:
      return AppStrings.hibrido;
    case Modalidad.PRESENCIAL:
      return AppStrings.presencial;
  }
}
