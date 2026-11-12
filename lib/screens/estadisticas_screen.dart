import 'package:flutter/material.dart';
import 'package:postulaciones_app/constants/app_strings.dart';
import 'package:postulaciones_app/layouts/background.dart';
import 'package:postulaciones_app/models/estadistica.dart';
import 'package:postulaciones_app/models/estado.dart';
import 'package:postulaciones_app/services/estadistica_service.dart';
import 'package:postulaciones_app/services/estado_service.dart';
import 'package:postulaciones_app/theme/app_colors.dart';
import 'package:postulaciones_app/utils/async_handler.dart';
import 'package:postulaciones_app/widgets/estadisticas/grafico_dias.dart';
import 'package:postulaciones_app/widgets/estadisticas/grafico_modalidades.dart';
import 'package:postulaciones_app/widgets/estadisticas/grafico_torta.dart';
import 'package:postulaciones_app/widgets/estadisticas/podio.dart';
import 'package:postulaciones_app/widgets/glass_card.dart';
import 'package:postulaciones_app/widgets/loading_overlay.dart';

class EstadisticasScreen extends StatefulWidget {
  const EstadisticasScreen({super.key});

  @override
  State<EstadisticasScreen> createState() => _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  final EstadisticaService _estadisticaService = EstadisticaService();
  final EstadoService _estadoService = EstadoService();

  List<EstadisticaEstado> postulacionesPorEstado = [];
  List<EstadisticaModalidad> postulacionesPorModalidad = [];
  List<EstadisticaFecha> postulacionesPorDia = [];
  List<RankingEstadistica> topEmpresas = [];
  List<RankingEstadistica> topPaginas = [];

  List<Estado> estados = [];

  bool cargandoE = false;
  bool cargandoP = false;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosIniciales();
    _cargarEstados();
    _obtenerTopEmpresas(null); // null = 'todos'
    _obtenerTopPaginas(null);
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

  Future<void> _obtenerTopEmpresas(int? estadoId) async {
    await AsyncHandler.ejecutar(
      context,
      tituloError: AppStrings.errorCargar,
      onLoading: (cargando) => setState(() => cargandoE = cargando),
      accion: () async {
        final r = await _estadisticaService.topEmpresas(estadoId: estadoId);
        if (!mounted) return;
        setState(() => topEmpresas = r);
      },
    );
  }

  Future<void> _obtenerTopPaginas(int? estadoId) async {
    await AsyncHandler.ejecutar(
      context,
      tituloError: AppStrings.errorCargar,
      onLoading: (cargando) => setState(() => cargandoP = cargando),
      accion: () async {
        final r = await _estadisticaService.topPaginas(estadoId: estadoId);
        if (!mounted) return;
        setState(() => topPaginas = r);
      },
    );
  }

  Future<void> _cargarEstados() async {
    await AsyncHandler.ejecutar(
      context,
      tituloError: AppStrings.errorCargar,
      onLoading: (cargando) => setState(() => this.cargando = cargando),
      accion: () async {
        final resultado = await _estadoService.obtenerEstados();

        if (!mounted) return;

        setState(() {
          estados = resultado;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool esOscuro = Theme.of(context).brightness == Brightness.dark;
    final double alpha = esOscuro ? 0 : 0.6;
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

              GlassCard(
                alpha: alpha,
                child: Podio(
                  titulo: 'Top empresas',
                  datos: topEmpresas,
                  estados: estados,
                  cargando: cargandoE,
                  onEstadoSeleccionado: _obtenerTopEmpresas,
                ),
              ),
              const SizedBox(height: 12),

              GlassCard(
                alpha: alpha,
                child: Podio(
                  titulo: 'Top páginas de aplicación',
                  unidad: 'Aplic.',
                  datos: topPaginas,
                  estados: estados,
                  cargando: cargandoP,
                  onEstadoSeleccionado: _obtenerTopPaginas,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
