import 'package:flutter/material.dart';
import 'package:postulaciones_app/constants/app_strings.dart';
import 'package:postulaciones_app/models/criterios_busqueda.dart';
import 'package:postulaciones_app/models/estado.dart';
import 'package:postulaciones_app/models/modalidad.dart';
import 'package:postulaciones_app/widgets/chip_option.dart';
import 'package:postulaciones_app/widgets/dashed_line.dart';

class FiltrosPostulaciones extends StatefulWidget {
  final List<Estado> estados;

  final Set<int> estadosSeleccionados;
  final Set<Modalidad> modalidadesSeleccionadas;
  final CriterioBusqueda criterioBusqueda;

  final ValueChanged<Set<int>> onEstadosChanged;
  final ValueChanged<Set<Modalidad>> onModalidadesChanged;
  final ValueChanged<CriterioBusqueda> onCriterioChanged;

  final VoidCallback onLimpiar;

  const FiltrosPostulaciones({
    super.key,
    required this.estados,
    required this.estadosSeleccionados,
    required this.modalidadesSeleccionadas,
    required this.criterioBusqueda,
    required this.onEstadosChanged,
    required this.onModalidadesChanged,
    required this.onCriterioChanged,
    required this.onLimpiar,
  });

  @override
  State<FiltrosPostulaciones> createState() => _FiltrosPostulacionesState();
}

class _FiltrosPostulacionesState extends State<FiltrosPostulaciones> {
  late Set<int> estados;
  late Set<Modalidad> modalidades;
  late CriterioBusqueda criterio;

  @override
  void initState() {
    super.initState();

    estados = {...widget.estadosSeleccionados};
    modalidades = {...widget.modalidadesSeleccionadas};
    criterio = widget.criterioBusqueda;
  }

  void _cambiarCriterio(CriterioBusqueda nuevo) {
    setState(() => criterio = nuevo);
    widget.onCriterioChanged(nuevo);
  }

  void _cambiarEstado(int id, bool seleccionado) {
    setState(() {
      if (seleccionado) {
        estados.add(id);
      } else {
        estados.remove(id);
      }
    });

    widget.onEstadosChanged({...estados});
  }

  void _cambiarModalidad(Modalidad modalidad, bool seleccionado) {
    setState(() {
      if (seleccionado) {
        modalidades.add(modalidad);
      } else {
        modalidades.remove(modalidad);
      }
    });

    widget.onModalidadesChanged({...modalidades});
  }

  void _limpiar() {
    setState(() {
      estados.clear();
      modalidades.clear();
      criterio = CriterioBusqueda.TODO;
    });

    widget.onLimpiar();
  }

  int get cantidadFiltrosActivos {
    return estados.length +
        modalidades.length +
        (criterio == CriterioBusqueda.TODO ? 0 : 1);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.filtros,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: cantidadFiltrosActivos == 0 ? null : _limpiar,
                  child: const Text(AppStrings.limpiarFiltros),
                ),
              ],
            ),

            const SizedBox(height: 4),
            const DashedLine(text: AppStrings.filtroBusqueda),
            const SizedBox(height: 4),

            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: CriterioBusqueda.values.map((cri) {
                  return ChipOption(
                    label: cri.nombreCriterio,
                    selected: criterio == cri,
                    unselectedFill: Colors.transparent,
                    onSelected: (_) => _cambiarCriterio(cri),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 4),
            const DashedLine(text: AppStrings.filtroEstado),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: widget.estados.map((estado) {
                  return ChipOption(
                    label: estado.nombre,
                    selected: estados.contains(estado.id),
                    color: estado.colorParsed,
                    showDot: true,
                    unselectedFill: Colors.transparent,
                    onSelected: (valor) {
                      _cambiarEstado(estado.id, valor);
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 4),
            const DashedLine(text: AppStrings.filtroModalidad),
            const SizedBox(height: 4),

            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: Modalidad.values.map((modalidad) {
                  return ChipOption(
                    label: modalidad.nombreModalidad,
                    selected: modalidades.contains(modalidad),
                    onSelected: (valor) {
                      _cambiarModalidad(modalidad, valor);
                    },
                    unselectedFill: Colors.transparent,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
