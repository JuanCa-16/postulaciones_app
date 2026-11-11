import 'package:flutter/material.dart';
import 'package:postulaciones_app/constants/app_strings.dart';
import 'package:postulaciones_app/layouts/background.dart';
import 'package:postulaciones_app/models/estadistica.dart';
import 'package:postulaciones_app/services/estadistica_service.dart';
import 'package:postulaciones_app/theme/app_colors.dart';
import 'package:postulaciones_app/utils/async_handler.dart';
import 'package:postulaciones_app/widgets/estadisticas/grafico_dias.dart';
import 'package:postulaciones_app/widgets/estadisticas/grafico_modalidades.dart';
import 'package:postulaciones_app/widgets/estadisticas/grafico_torta.dart';
import 'package:postulaciones_app/widgets/glass_card.dart';
import 'package:postulaciones_app/widgets/loading_overlay.dart';

class EstadisticasScreen extends StatefulWidget {
  const EstadisticasScreen({super.key});

  @override
  State<EstadisticasScreen> createState() => _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  final EstadisticaService _estadisticaService = EstadisticaService();

  List<EstadisticaEstado> postulacionesPorEstado = [];
  List<EstadisticaModalidad> postulacionesPorModalidad = [];
  List<EstadisticaFecha> postulacionesPorDia = [];

  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosIniciales();
  }

  Future<void> _cargarDatosIniciales() async {
    await AsyncHandler.ejecutar(
      context,
      tituloError: AppStrings.errorCargar,
      onLoading: (cargando) => setState(() => this.cargando = cargando),
      accion: () async {
        final resultados = await Future.wait([
          _estadisticaService.postulacionesPorEstado(),
          _estadisticaService.postulacionesPorModalidad(),
          _estadisticaService.postulacionesPorDia(),
        ]);

        if (!mounted) return;

        setState(() {
          postulacionesPorEstado = resultados[0] as List<EstadisticaEstado>;
          postulacionesPorModalidad =
              resultados[1] as List<EstadisticaModalidad>;
          postulacionesPorDia = resultados[2] as List<EstadisticaFecha>;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool esOscuro = Theme.of(context).brightness == Brightness.dark;
    final double alpha = esOscuro ? 0 : 0.4;
    return LoadingOverlay(
      loading: cargando,
      child: Background(
        safeArea: false,
        statusColor: context.colors.mainColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            16,
            16 + MediaQuery.paddingOf(context).top,
            16,
            16 + MediaQuery.paddingOf(context).bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GlassCard(
                alpha: alpha,
                child: GraficoModalidades(
                  estadisticas: postulacionesPorModalidad,
                  total: postulacionesPorModalidad.fold(
                    0,
                    (s, m) => s + m.cantidad,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              GlassCard(
                alpha: alpha,
                child: GraficoTorta(estadisticas: postulacionesPorEstado),
              ),

              const SizedBox(height: 12),

              GlassCard(
                alpha: alpha,
                child: GraficoDias(estadisticas: postulacionesPorDia),
              ),

              const SizedBox(height: 12),

              GlassCard(alpha: alpha, child: const Text('Modalidades')),
              const SizedBox(height: 12),

              GlassCard(alpha: alpha, child: const Text('Top empresas')),
              const SizedBox(height: 12),

              GlassCard(
                alpha: alpha,
                child: const Text('Top páginas de aplicación'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
