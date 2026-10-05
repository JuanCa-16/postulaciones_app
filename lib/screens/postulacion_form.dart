import 'package:flutter/material.dart';
import 'package:postulaciones_app/layouts/card_layout.dart';
import 'package:postulaciones_app/models/estado.dart';
import 'package:postulaciones_app/models/modalidad.dart';
import 'package:postulaciones_app/models/postulacion.dart';
import 'package:postulaciones_app/theme/app_colors.dart';
import 'package:postulaciones_app/widgets/dashed_line.dart';
import 'package:postulaciones_app/widgets/input_field.dart';
import 'package:postulaciones_app/widgets/loading_overlay.dart';

class PostulacionForm extends StatefulWidget {
  final PostulacionFormulario? datosIniciales;
  final List<Estado> estados;
  final Color? color;
  final void Function(PostulacionFormulario postulacion) onSubmit;

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

  bool cargando = false;

  @override
  void initState() {
    super.initState();

    modalidad = modalidad =
        widget.datosIniciales?.modalidad ?? Modalidad.REMOTO;
    estadoId =
        widget.datosIniciales?.estadoId ??
        widget.estados.firstWhere((estado) => estado.porDefecto).id;
  }

  @override
  void dispose() {
    _empresaFocus.dispose();
    _urlFocus.dispose();
    _paginaAplicacionFocus.dispose();

    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() {
      cargando = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      cargando = false;
    });

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

    widget.onSubmit(postulacion);
  }

  @override
  Widget build(BuildContext context) {
    final datos = widget.datosIniciales;
    return LoadingOverlay(
      loading: cargando,
      child: CardLayout(
        color: widget.color,
        title: datos == null ? 'Crear Nueva Postulación' : 'Editar Postulación',
        description:
            'Ingresa las características y el estado actual de la oferta',
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputField(
                label: 'Nombre de la oferta *',
                initialValue: datos?.nombreOferta,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre de la oferta es obligatorio.';
                  }

                  return null;
                },
                onSaved: (value) {
                  nombreOferta = value ?? '';
                },
                onFieldSubmitted: (_) {
                  _empresaFocus.requestFocus();
                },
              ),

              const SizedBox(height: 15),

              InputField(
                label: 'Empresa ',
                initialValue: datos?.nombreEmpresa,
                keyboardType: TextInputType.text,
                focusNode: _empresaFocus,
                onSaved: (value) {
                  nombreEmpresa = value ?? '';
                },
                onFieldSubmitted: (_) {
                  _urlFocus.requestFocus();
                },
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: InputField(
                      label: 'URL de la oferta',
                      initialValue: datos?.url,
                      keyboardType: TextInputType.url,
                      focusNode: _urlFocus,
                      onSaved: (value) {
                        url = value ?? '';
                      },
                      onFieldSubmitted: (_) {
                        _paginaAplicacionFocus.requestFocus();
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: InputField(
                      label: 'Plataforma / Portal',
                      initialValue: datos?.paginaAplicacion,
                      keyboardType: TextInputType.text,
                      focusNode: _paginaAplicacionFocus,
                      onSaved: (value) {
                        paginaAplicacion = value ?? '';
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Text(
                'Modalidad *'.toUpperCase(),
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
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                      selected: modalidad == modalidadItem,
                      showCheckmark: false,
                      color: WidgetStateColor.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.buttonPrimary;
                        }

                        return AppColors.inputBackground;
                      }),

                      onSelected: (_) {
                        setState(() => modalidad = modalidadItem);
                      },
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 15),

              Text(
                'Estado actual *'.toUpperCase(),
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
                      side: BorderSide(
                        color: AppColors.inputFocusedBorder,
                        width: 1,
                      ),
                      onSelected: (_) {
                        setState(() => estadoId = estado.id);
                      },
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
                  onPressed: cargando ? null : _guardar,
                  child: Text(
                    datos == null ? 'Crear postulación' : 'Guardar cambios',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String nombreModalidad(Modalidad modalidad) {
  switch (modalidad) {
    case Modalidad.REMOTO:
      return 'Remoto';
    case Modalidad.HIBRIDO:
      return 'Híbrido';
    case Modalidad.PRESENCIAL:
      return 'Presencial';
  }
}
