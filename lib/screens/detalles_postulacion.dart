import 'package:flutter/material.dart';
import 'package:postulaciones_app/constants/app_strings.dart';
import 'package:postulaciones_app/layouts/background_top.dart';
import 'package:postulaciones_app/layouts/timeline.dart';
import 'package:postulaciones_app/models/historial.dart';
import 'package:postulaciones_app/models/postulacion.dart';
import 'package:postulaciones_app/screens/editar_postulacion.dart';
import 'package:postulaciones_app/services/postulacion_service.dart';
import 'package:postulaciones_app/theme/app_colors.dart';
import 'package:postulaciones_app/widgets/dashed_line.dart';
import 'package:postulaciones_app/widgets/glass_card.dart';
import 'package:postulaciones_app/widgets/label_text.dart';
import 'package:postulaciones_app/widgets/loading_overlay.dart';
import 'package:postulaciones_app/widgets/status_tag.dart';
import 'package:postulaciones_app/widgets/confirm_dialog.dart';
import 'package:postulaciones_app/utils/async_handler.dart';

class DetallesPostulacion extends StatefulWidget {
  final Postulacion postulacion;
  const DetallesPostulacion({super.key, required this.postulacion});

  @override
  State<DetallesPostulacion> createState() => _DetallesPostulacionState();
}

class _DetallesPostulacionState extends State<DetallesPostulacion> {
  final PostulacionService _postulacionService = PostulacionService();

  Postulacion? postulacion;
  List<Historial> historial = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    postulacion = widget.postulacion;
    _cargarDetalles();
  }

  Future<void> _cargarDetalles() async {
    await AsyncHandler.ejecutar(
      context,
      tituloError: AppStrings.errorCargar,
      onLoading: (cargando) => setState(() => this.cargando = cargando),
      accion: () async {
        final resultado = await _postulacionService.obtenerDetallePostulacion(
          postulacion!.id,
        );

        if (!mounted) return;

        setState(() {
          postulacion = resultado;
          historial = resultado.historial ?? [];
          cargando = false;
        });
      },
    );
  }

  Future<void> _eliminarPostulacion(int id) async {
    await AsyncHandler.ejecutar(
      context,
      tituloError: AppStrings.errorEliminar,
      onLoading: (cargando) => setState(() => this.cargando = cargando),
      accion: () async {
        await _postulacionService.eliminarPostulacion(id);

        if (!mounted) return;
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundTop(
        statusColor: postulacion!.estado.colorParsed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      postulacion!.nombreOferta,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),

                  const SizedBox(width: 14),

                  StatusTag(
                    label: postulacion!.estado.nombre,
                    color: postulacion!.estado.colorParsed,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        if (postulacion!.nombreEmpresa != null &&
                            postulacion!.nombreEmpresa!.trim().isNotEmpty)
                          LabelText(
                            label: AppStrings.empresa,
                            text: postulacion!.nombreEmpresa!,
                          ),

                        if (postulacion!.paginaAplicacion != null &&
                            postulacion!.paginaAplicacion!.trim().isNotEmpty)
                          LabelText(
                            label: AppStrings.pagAplicacion,
                            text: postulacion!.paginaAplicacion!,
                          ),

                        LabelText(
                          label: AppStrings.modalidad,
                          text: postulacion!.modalidad.valor,
                          hightlight: true,
                        ),

                        if (postulacion!.fecha.trim().isNotEmpty)
                          LabelText(
                            label: AppStrings.fecha,
                            text: postulacion!.fechaFormateada,
                          ),
                      ],
                    ),
                    if (postulacion!.url != null &&
                        postulacion!.url!.trim().isNotEmpty) ...[
                      const SizedBox(height: 16),

                      const DashedLine(),

                      const SizedBox(height: 16),

                      LabelText(
                        label: AppStrings.urlOferta,
                        text: postulacion!.url!,
                        urlFormat: true,
                        onTap: postulacion!.abrirUrl,
                        color: postulacion!.estado.colorParsed,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Text(
                AppStrings.historial,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.left,
              ),

              const SizedBox(height: 12),

              Expanded(
                child: LoadingOverlay(
                  loading: cargando,
                  variant: true,
                  color: postulacion!.estado.colorParsed,
                  child: Timeline(
                    color: postulacion!.estado.colorParsed,
                    historialList: historial,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'editar',
            backgroundColor: postulacion!.estado.colorParsed,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditarPostulacion(postulacion: postulacion!),
                ),
              );
              if (!mounted) return;

              await _cargarDetalles();
            },
            child: Icon(Icons.edit, color: context.colors.background),
          ),
          const SizedBox(height: 12),

          FloatingActionButton(
            heroTag: 'eliminar',
            backgroundColor: context.colors.danger,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return ConfirmDialog(
                    title: AppStrings.eliminar,
                    message: AppStrings.confirmarEliminacion,
                    confirmText: AppStrings.eliminar,
                    onConfirm: () => _eliminarPostulacion(postulacion!.id),
                  );
                },
              );
            },
            child: Icon(Icons.delete, color: context.colors.background),
          ),
        ],
      ),
    );
  }
}
