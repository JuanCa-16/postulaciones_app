import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:postulaciones_app/models/estado.dart';
import 'package:postulaciones_app/widgets/dashed_line.dart';
import 'package:postulaciones_app/widgets/glass_card.dart';
import 'package:postulaciones_app/widgets/input_field.dart';
import 'package:postulaciones_app/theme/app_colors.dart';
import 'package:postulaciones_app/widgets/status_tag.dart';

class EstadoCard extends StatefulWidget {
  final EstadoFormulario estado;
  final void Function(String nombre, Color color, bool porDefecto)? onGuardar;
  final VoidCallback? onEliminar;

  const EstadoCard({
    super.key,
    required this.estado,
    this.onGuardar,
    this.onEliminar,
  });

  @override
  State<EstadoCard> createState() => _EstadoCardState();
}

class _EstadoCardState extends State<EstadoCard> {
  late String nombre;
  late Color color;
  late bool porDefecto;

  @override
  void initState() {
    super.initState();
    nombre = widget.estado.nombre;
    color = widget.estado.colorParsed;
    porDefecto = widget.estado.porDefecto;
  }

  @override
  void didUpdateWidget(covariant EstadoCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.estado != widget.estado) {
      nombre = widget.estado.nombre;
      color = widget.estado.colorParsed;
      porDefecto = widget.estado.porDefecto;
    }
  }

  bool get haCambiado =>
      nombre.trim() != widget.estado.nombre ||
      color != widget.estado.colorParsed ||
      porDefecto != widget.estado.porDefecto;

  bool get _nombreValido => nombre.trim().isNotEmpty;

  Future<void> _elegirColor() async {
    Color temporal = color;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Elige un color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: color,
            onColorChanged: (c) => temporal = c,
            enableAlpha: false, // sin barra de transparencia
            labelTypes: const [], // oculta etiquetas RGB/HSV (opcional)
            pickerAreaBorderRadius: BorderRadius.circular(12),
            pickerAreaHeightPercent: 0.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() => color = temporal);
              Navigator.pop(context);
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final card = GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InputField(
                  initialValue: widget.estado.nombre,
                  placeholder: 'Nombre del estado',
                  maxLength: 15,
                  onChanged: (v) => setState(() => nombre = v ?? ''),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _elegirColor,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.inputFocusedBorder),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ChoiceChip(
                label: Text(
                  'Defecto',
                  style: TextStyle(
                    color: porDefecto
                        ? AppColors.buttonPrimary
                        : AppColors.textSecondary,
                  ),
                ),
                selected: porDefecto,
                showCheckmark: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: porDefecto
                        ? AppColors.buttonPrimary
                        : AppColors.inputFocusedBorder,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                color: WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.buttonPrimary.withValues(alpha: 0.15);
                  }
                  return AppColors.inputBackground;
                }),
                onSelected: (v) => setState(() => porDefecto = v),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Chip "Defecto" + botón guardar
          const DashedLine(),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        'Vista previa:',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(width: 8),
                      StatusTag(
                        label: nombre.trim().isEmpty ? '...' : nombre.trim(),
                        color: color,
                      ),
                    ],
                  ),
                ),
              ),
              if (haCambiado && _nombreValido)
                IconButton(
                  icon: const Icon(Icons.check),
                  color: AppColors.buttonPrimary,
                  tooltip: 'Guardar cambios',
                  onPressed: () =>
                      widget.onGuardar?.call(nombre.trim(), color, porDefecto),
                ),
            ],
          ),
        ],
      ),
    );

    if (widget.onEliminar == null) {
      return card;
    }
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.2,
        children: [
          CustomSlidableAction(
            onPressed: (_) => widget.onEliminar?.call(),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.red,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.delete, color: Colors.red, size: 22),
              ),
            ),
          ),
        ],
      ),
      child: card,
    );
  }
}
