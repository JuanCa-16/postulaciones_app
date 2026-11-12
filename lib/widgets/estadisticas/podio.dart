import 'package:flutter/material.dart';
import 'package:postulaciones_app/models/estadistica.dart';
import 'package:postulaciones_app/models/estado.dart';
import 'package:postulaciones_app/theme/app_colors.dart';
import 'package:postulaciones_app/widgets/chip_option.dart';
import 'package:postulaciones_app/widgets/dashed_line.dart';
import 'package:postulaciones_app/widgets/loading_overlay.dart';

const _alturas = {1: 120.0, 2: 88.0, 3: 64.0};

// Sub-animación: la parte [a, b] (0..1) del controller principal.
Animation<double> _tramo(
  Animation<double> p,
  double a,
  double b, [
  Curve curve = Curves.easeOut,
]) => p.drive(CurveTween(curve: Interval(a, b.clamp(0.0, 1.0), curve: curve)));

class Podio extends StatefulWidget {
  final String titulo;
  final List<RankingEstadistica> datos; // ordenados, máx. 5
  final String unidad;
  final bool cargando;
  final List<Estado> estados;
  final ValueChanged<int?> onEstadoSeleccionado; // null = "Todos"

  const Podio({
    super.key,
    required this.titulo,
    required this.datos,
    required this.onEstadoSeleccionado,
    this.unidad = 'Postul.',
    this.cargando = false,
    this.estados = const [],
  });

  @override
  State<Podio> createState() => _PodioState();
}

class _PodioState extends State<Podio> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );
  int? _estadoId;

  @override
  void initState() {
    super.initState();
    if (widget.datos.isNotEmpty) _ctrl.forward();
  }

  @override
  void didUpdateWidget(covariant Podio old) {
    super.didUpdateWidget(old);
    // Datos nuevos (carga o filtro) -> vuelve a animar el podio
    if (!identical(old.datos, widget.datos)) _ctrl.forward(from: 0);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Color get _color {
    final base = context.colors.mainColor;
    if (_estadoId == null) return base;
    final estado = widget.estados.where((e) => e.id == _estadoId).firstOrNull;
    return estado?.colorParsed ?? base;
  }

  void _seleccionar(int? id) {
    if (id == _estadoId) return;
    setState(() => _estadoId = id);
    widget.onEstadoSeleccionado(id);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final top = widget.datos.take(5).toList();

    // Orden visual: 2º, 1º, 3º
    final podio = [1, 0, 2].where((i) => i < top.length).toList();
    final resto = top.length > 3 ? top.sublist(3) : <RankingEstadistica>[];

    return LoadingOverlay(
      loading: widget.cargando,
      variant: true,
      color: _color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ---------- TÍTULO ----------
          Text(
            widget.titulo.toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          DashedLine(),
          const SizedBox(height: 12),

          // ---------- FILTRO POR ESTADO ----------
          if (widget.estados.isNotEmpty) ...[
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 8,
                runSpacing:
                    0, // para que al hacer wrap haya espacio entre filas
                alignment: WrapAlignment.center,
                children: [
                  ChipOption(
                    label: 'Todos',
                    selected: _estadoId == null,
                    color: colors.mainColor,
                    onSelected: (_) => _seleccionar(null),
                  ),
                  for (final estado in widget.estados)
                    ChipOption(
                      label: estado.nombre,
                      selected: _estadoId == estado.id,
                      color: estado.colorParsed,
                      showDot: true,
                      onSelected: (_) => _seleccionar(estado.id),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ---------- CONTENIDO ----------
          if (top.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'Aún no hay datos',
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.textPrimary.withValues(alpha: 0.6),
                  ),
                ),
              ),
            )
          else
            // El color cambia suave al filtrar por otro estado
            TweenAnimationBuilder<Color?>(
              tween: ColorTween(end: _color),
              duration: const Duration(milliseconds: 400),
              builder: (context, color, _) {
                final c = color ?? colors.mainColor;
                return RepaintBoundary(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (final i in podio)
                            Flexible(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 150,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: _Puesto(
                                    item: top[i],
                                    pos: i + 1,
                                    color: c,
                                    unidad: widget.unidad,
                                    anim: _ctrl,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (resto.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Divider(
                          height: 1,
                          color: colors.mainColor.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 12),
                        for (var i = 0; i < resto.length; i++)
                          _Entrada(
                            animation: _tramo(
                              _ctrl,
                              0.6 + i * 0.08,
                              0.9 + i * 0.08,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _Fila(
                                pos: i + 4,
                                item: resto[i],
                                color: c,
                                unidad: widget.unidad,
                              ),
                            ),
                          ),
                      ],
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------
// Un puesto del podio: corona + cantidad + nombre + pedestal
// ---------------------------------------------------------------
class _Puesto extends StatelessWidget {
  final RankingEstadistica item;
  final int pos;
  final Color color;
  final String unidad;
  final Animation<double> anim;

  const _Puesto({
    required this.item,
    required this.pos,
    required this.color,
    required this.unidad,
    required this.anim,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final alto = _alturas[pos]!;

    // El 3º entra primero y el 1º al final
    final ini = (3 - pos) * 0.1;
    final subir = _tramo(anim, ini, ini + 0.45, Curves.easeOutBack);
    final textos = _tramo(anim, ini + 0.35, ini + 0.6);
    final conteo = _tramo(anim, ini + 0.3, ini + 0.7, Curves.easeOutCubic);
    final corona = _tramo(anim, 0.7, 0.95, Curves.easeOutBack);

    final colorPedestal = switch (pos) {
      1 => color,
      2 => Color.lerp(colors.background, color, 0.65)!,
      _ => Color.lerp(colors.background, color, 0.40)!,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (pos == 1)
          ScaleTransition(
            scale: corona,
            child: const Text('👑', style: TextStyle(fontSize: 22)),
          ),
        const SizedBox(height: 4),

        // Cantidad con conteo animado
        _Entrada(
          animation: textos,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: AnimatedBuilder(
              animation: conteo,
              builder: (context, _) => Text(
                '${(item.cantidad * conteo.value).round()} $unidad',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),

        // Nombre
        _Entrada(
          animation: textos,
          child: Text(
            item.nombre,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: colors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 4),

        // Pedestal: el espacio es fijo, solo se escala lo pintado
        SizedBox(
          height: alto,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AnimatedBuilder(
                animation: subir,
                builder: (context, child) => Transform(
                  alignment: Alignment.bottomCenter,
                  transform: Matrix4.diagonal3Values(
                    1,
                    subir.value.clamp(0.0, 1.2),
                    1,
                  ),
                  child: child,
                ),
                child: Container(
                  height: alto,
                  decoration: BoxDecoration(
                    color: colorPedestal,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    boxShadow: pos == 1
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.3),
                              blurRadius: 24,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: FadeTransition(
                    opacity: _tramo(anim, ini + 0.25, ini + 0.5),
                    child: Text(
                      '#$pos',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: colors.background.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------
// Puestos 4 y 5
// ---------------------------------------------------------------
class _Fila extends StatelessWidget {
  final int pos;
  final RankingEstadistica item;
  final Color color;
  final String unidad;

  const _Fila({
    required this.pos,
    required this.item,
    required this.color,
    required this.unidad,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.12),
          ),
          child: Text(
            '$pos',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            item.nombre,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13, color: colors.textPrimary),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${item.cantidad} $unidad',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

// --------------------------------------------------------------
// Aparecer: fade + subida de 8px (el "aparecer" del SCSS)
// ---------------------------------------------------------------
class _Entrada extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _Entrada({required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.4),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}
