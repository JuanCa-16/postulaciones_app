import 'package:flutter/material.dart';
import 'package:postulaciones_app/models/estadistica.dart';
import 'package:postulaciones_app/theme/app_colors.dart';

const _meses = [
  'Enero',
  'Febrero',
  'Marzo',
  'Abril',
  'Mayo',
  'Junio',
  'Julio',
  'Agosto',
  'Septiembre',
  'Octubre',
  'Noviembre',
  'Diciembre',
];
const _diasSemana = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
const _diasLargos = [
  'Lunes',
  'Martes',
  'Miércoles',
  'Jueves',
  'Viernes',
  'Sábado',
  'Domingo',
];
const _espacio = 6.0; // espacio entre celdas
const _margenPagina = 12.0; // margen lateral de cada página del PageView

class GraficoDias extends StatefulWidget {
  final List<EstadisticaFecha> estadisticas;

  const GraficoDias({super.key, required this.estadisticas});

  @override
  State<GraficoDias> createState() => _GraficoDiasState();
}

class _GraficoDiasState extends State<GraficoDias> {
  late final int _anio;
  late final ValueNotifier<int> _mes; // 0..11
  final ValueNotifier<DateTime?> _seleccionado = ValueNotifier(null);
  late final PageController _controller;
  late Map<DateTime, int> _porDia;

  @override
  void initState() {
    super.initState();
    final hoy = DateTime.now();
    _anio = widget.estadisticas.isNotEmpty
        ? widget.estadisticas.first.fecha.year
        : hoy.year;
    // Abre en el mes actual (si el año de los datos es otro, en enero)
    final mesInicial = hoy.year == _anio ? hoy.month - 1 : 0;
    _mes = ValueNotifier(mesInicial);
    _controller = PageController(initialPage: mesInicial);
    _indexar();
  }

  @override
  void didUpdateWidget(covariant GraficoDias old) {
    super.didUpdateWidget(old);
    if (old.estadisticas != widget.estadisticas) _indexar();
  }

  void _indexar() {
    _porDia = {for (final e in widget.estadisticas) e.fecha: e.cantidad};
  }

  @override
  void dispose() {
    _controller.dispose();
    _mes.dispose();
    _seleccionado.dispose();
    super.dispose();
  }

  void _irA(int mes) {
    _controller.animateToPage(
      mes,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  // Rangos: 0 / 1-3 / 4-5 / 6+ (sólidos, sin transparencia)
  Color _color(int n) {
    final c = context.colors;
    if (n == 0) return c.mainColor.withValues(alpha: 0.10);
    if (n <= 3) return Color.lerp(c.background, c.mainColor, 0.30)!;
    if (n <= 5) return Color.lerp(c.background, c.mainColor, 0.75)!;
    return c.mainColor;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------- ENCABEZADO: mes y flechas ----------
        ValueListenableBuilder<int>(
          valueListenable: _mes,
          builder: (context, mes, _) {
            return Row(
              children: [
                IconButton(
                  onPressed: mes > 0 ? () => _irA(mes - 1) : null,
                  icon: const Icon(Icons.chevron_left_rounded),
                  color: colors.mainColor,
                ),
                Expanded(
                  child: Text(
                    '${_meses[mes]} $_anio',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: mes < 11 ? () => _irA(mes + 1) : null,
                  icon: const Icon(Icons.chevron_right_rounded),
                  color: colors.mainColor,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 8),

        // ---------- DÍAS DE LA SEMANA + MESES ----------
        LayoutBuilder(
          builder: (context, c) {
            // El ancho real de la cuadrícula descuenta el margen de la página
            final anchoGrid = c.maxWidth - _margenPagina * 2;
            final celda = (anchoGrid - _espacio * 6) / 7;
            // Alto fijo para 6 filas: meses de 5 o 6 semanas no hacen saltar la tarjeta
            final alto = celda * 6 + _espacio * 5;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _margenPagina,
                  ),
                  child: Row(
                    children: [
                      for (final d in _diasSemana)
                        Expanded(
                          child: Center(
                            child: Text(
                              d,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: alto,
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: 12,
                    onPageChanged: (i) {
                      _mes.value = i;
                      _seleccionado.value = null;
                    },
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: _margenPagina,
                      ),
                      child: _MesGrid(
                        anio: _anio,
                        mes: i + 1,
                        datos: _porDia,
                        colorDe: _color,
                        seleccionado: _seleccionado,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),

        // ---------- DETALLE DEL DÍA TOCADO ----------
        ValueListenableBuilder<DateTime?>(
          valueListenable: _seleccionado,
          builder: (context, sel, _) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                sel == null
                    ? 'Toca un día para ver el detalle'
                    : '${_diasLargos[sel.weekday - 1]} ${sel.day} de '
                          '${_meses[sel.month - 1].toLowerCase()}: '
                          '${_porDia[sel] ?? 0} postulaciones',
                key: ValueKey(sel),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: colors.textSecondary),
              ),
            );
          },
        ),
        const SizedBox(height: 12),

        // ---------- LEYENDA ----------
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 8,
          children: [
            _Leyenda(color: _color(0), texto: '0'),
            _Leyenda(color: _color(1), texto: '1-3'),
            _Leyenda(color: _color(4), texto: '4-5'),
            _Leyenda(color: _color(6), texto: '6+'),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------
// Cuadrícula de un mes (se mantiene viva al deslizar)
// ---------------------------------------------------------------
class _MesGrid extends StatefulWidget {
  final int anio;
  final int mes; // 1..12
  final Map<DateTime, int> datos;
  final Color Function(int) colorDe;
  final ValueNotifier<DateTime?> seleccionado;

  const _MesGrid({
    required this.anio,
    required this.mes,
    required this.datos,
    required this.colorDe,
    required this.seleccionado,
  });

  @override
  State<_MesGrid> createState() => _MesGridState();
}

class _MesGridState extends State<_MesGrid> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void _tocarDia(DateTime fecha) {
    widget.seleccionado.value = widget.seleccionado.value == fecha
        ? null
        : fecha;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // obligatorio con AutomaticKeepAliveClientMixin

    final colors = context.colors;
    final diasMes = DateUtils.getDaysInMonth(widget.anio, widget.mes);
    final offset =
        DateTime(widget.anio, widget.mes, 1).weekday - 1; // lunes = 0
    final hoy = DateUtils.dateOnly(DateTime.now());

    return ValueListenableBuilder<DateTime?>(
      valueListenable: widget.seleccionado,
      builder: (context, sel, _) {
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: 42, // 6 filas x 7
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: _espacio,
            crossAxisSpacing: _espacio,
          ),
          itemBuilder: (context, i) {
            final dia = i - offset + 1;
            if (dia < 1 || dia > diasMes) return const SizedBox.shrink();

            final fecha = DateTime(widget.anio, widget.mes, dia);
            final n = widget.datos[fecha] ?? 0;
            final fondo = widget.colorDe(n);
            final esSel = sel == fecha;
            final esHoy = fecha == hoy;

            final textoColor =
                ThemeData.estimateBrightnessForColor(fondo) == Brightness.dark
                ? Colors.white
                : colors.textPrimary;

            return GestureDetector(
              onTap: () => _tocarDia(fecha),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: fondo,
                  borderRadius: BorderRadius.circular(8),
                  border: esSel
                      ? Border.all(color: colors.textPrimary, width: 2)
                      : esHoy
                      ? Border.all(color: colors.mainColor, width: 1.5)
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$dia',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: esHoy ? FontWeight.w800 : FontWeight.w500,
                    color: textoColor,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _Leyenda extends StatelessWidget {
  final Color color;
  final String texto;

  const _Leyenda({required this.color, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          texto,
          style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
        ),
      ],
    );
  }
}
