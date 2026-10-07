import 'package:flutter/material.dart';
import 'package:postulaciones_app/layouts/background_top.dart';
import 'package:postulaciones_app/layouts/timeline.dart';
import 'package:postulaciones_app/models/historial.dart';
import 'package:postulaciones_app/models/postulacion.dart';
import 'package:postulaciones_app/screens/editar_postulacion.dart';
import 'package:postulaciones_app/services/postulacion_service.dart';
import 'package:postulaciones_app/theme/app_colors.dart';
import 'package:postulaciones_app/widgets/dashed_line.dart';
import 'package:postulaciones_app/widgets/dialog_helper.dart';
import 'package:postulaciones_app/widgets/glass_card.dart';
import 'package:postulaciones_app/widgets/label_text.dart';
import 'package:postulaciones_app/widgets/loading_overlay.dart';
import 'package:postulaciones_app/widgets/status_tag.dart';
import 'package:postulaciones_app/widgets/confirm_dialog.dart';

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
  String? error;

  @override
  void initState() {
    super.initState();
    postulacion = widget.postulacion;
    _cargarDetalles();
  }

  Future<void> _cargarDetalles() async {
    setState(() {
      cargando = true;
      error = null;
    });

    try {
      final resultado = await _postulacionService.obtenerDetallePostulacion(
        postulacion!.id,
      );

      if (!mounted) return;

      setState(() {
        postulacion = resultado;
        historial = resultado.historial ?? [];
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      final mensaje = e.toString().replaceFirst('Exception: ', '');

      setState(() {
        cargando = false;
        error = mensaje;
      });
    }
  }

  Future<void> _eliminarPostulacion(int id) async {
    setState(() {
      cargando = true;
    });

    try {
      await _postulacionService.eliminarPostulacion(id);

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      final mensaje = e.toString().replaceFirst('Exception: ', '');

      await DialogHelper.mostrarError(
        context,
        mensaje,
        titulo: 'Error al eliminar postulacion',
      );
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
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
                  SizedBox(width: 14),
                  StatusTag(
                    label: postulacion!.estado.nombre,
                    color: postulacion!.estado.colorParsed,
                  ),
                ],
              ),
              SizedBox(height: 16),
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
                            label: 'Empresa',
                            text: postulacion!.nombreEmpresa!,
                          ),

                        if (postulacion!.paginaAplicacion != null &&
                            postulacion!.paginaAplicacion!.trim().isNotEmpty)
                          LabelText(
                            label: 'Página aplicación',
                            text: postulacion!.paginaAplicacion!,
                          ),

                        LabelText(
                          label: 'Modalidad',
                          text: postulacion!.modalidad.valor,
                          hightlight: true,
                        ),

                        if (postulacion!.fecha.trim().isNotEmpty)
                          LabelText(
                            label: 'Fecha postulación',
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
                        label: 'Enlace de oferta',
                        text: postulacion!.url!,
                        urlFormat: true,
                        onTap: postulacion!.abrirUrl,
                        color: postulacion!.estado.colorParsed,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Historial de Cambios',
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
            child: const Icon(Icons.edit, color: AppColors.inputBackground),
          ),
          const SizedBox(height: 12),

          FloatingActionButton(
            heroTag: 'eliminar',
            backgroundColor: Colors.red,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return ConfirmDialog(
                    title: 'Eliminar postulación',
                    message:
                        '¿Estás seguro de que deseas eliminar esta postulación?',
                    confirmText: 'Eliminar',
                    onConfirm: () => _eliminarPostulacion(postulacion!.id),
                  );
                },
              );
            },
            child: const Icon(Icons.delete, color: AppColors.inputBackground),
          ),
        ],
      ),
    );
  }
}
