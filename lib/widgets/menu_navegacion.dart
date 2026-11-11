import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:postulaciones_app/screens/estadisticas_screen.dart';
import 'package:postulaciones_app/screens/inicio.dart';
import 'package:postulaciones_app/theme/app_colors.dart';

class MenuNavegacion extends StatefulWidget {
  const MenuNavegacion({super.key});

  @override
  State<MenuNavegacion> createState() => _MenuNavegacionState();
}

class _MenuNavegacionState extends State<MenuNavegacion>
    with SingleTickerProviderStateMixin {
  int indiceSeleccionado = 0;

  // Para llamar a crearPostulacion() de Inicio desde el FAB
  final _inicioKey = GlobalKey<InicioState>();

  // 1 = barra visible, 0 = oculta
  late final AnimationController _barraCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
    value: 1,
  );
  late final Animation<double> _barraAnim = CurvedAnimation(
    parent: _barraCtrl,
    curve: Curves.easeInOut,
  );

  @override
  void dispose() {
    _barraCtrl.dispose();
    super.dispose();
  }

  bool _onScroll(UserScrollNotification n) {
    // Solo scroll vertical y de la lista principal (no el del calendario)
    if (n.metrics.axis != Axis.vertical || n.depth != 0) return false;

    if (n.direction == ScrollDirection.reverse) {
      _barraCtrl.reverse(); // bajando -> ocultar
    } else if (n.direction == ScrollDirection.forward) {
      _barraCtrl.forward(); // subiendo -> mostrar
    }
    return false; // no cortar la propagación
  }

  @override
  Widget build(BuildContext context) {
    // Altura total de la barra: la barra + la zona segura del sistema
    final alturaBarra = 60 + MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      extendBody: true,
      body: NotificationListener<UserScrollNotification>(
        onNotification: _onScroll,
        child: IndexedStack(
          index: indiceSeleccionado,
          children: [
            Inicio(key: _inicioKey),
            if (indiceSeleccionado == 1)
              const EstadisticasScreen()
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
      floatingActionButton: indiceSeleccionado == 0
          ? AnimatedBuilder(
              animation: _barraAnim,
              builder: (context, child) => Transform.translate(
                // baja junto con la barra, solo pintado, sin relayout
                offset: Offset(0, (1 - _barraAnim.value) * alturaBarra),
                child: child,
              ),
              child: FloatingActionButton(
                onPressed: () => _inicioKey.currentState?.crearPostulacion(),
                child: Icon(
                  Icons.add,
                  color: context.colors.background,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
      bottomNavigationBar: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1), // totalmente abajo (oculta)
          end: Offset.zero,
        ).animate(_barraAnim),
        child: RepaintBoundary(child: _barra(context)),
      ),
    );
  }

  Widget _barra(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: ColoredBox(
          color: context.colors.background.withValues(alpha: 0.2),

          child: NavigationBar(
            height: 60,
            elevation: 0,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            indicatorColor: context.colors.mainColor.withValues(alpha: 0.15),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            selectedIndex: indiceSeleccionado,
            onDestinationSelected: (i) {
              setState(() => indiceSeleccionado = i);
              _barraCtrl.forward(); // al cambiar de pestaña, siempre visible
            },
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Icons.work_outline,
                  color: context.colors.textSecondary,
                ),
                selectedIcon: Icon(Icons.work, color: context.colors.mainColor),
                label: 'Postulaciones',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.bar_chart_outlined,
                  color: context.colors.textSecondary,
                ),
                selectedIcon: Icon(
                  Icons.bar_chart,
                  color: context.colors.mainColor,
                ),
                label: 'Estadísticas',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
