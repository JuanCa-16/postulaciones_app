import 'package:flutter/material.dart';
import 'package:postulaciones_app/screens/estadisticas_screen.dart';
import 'package:postulaciones_app/screens/inicio.dart';
import 'package:postulaciones_app/theme/app_colors.dart';

class MenuNavegacion extends StatefulWidget {
  const MenuNavegacion({super.key});

  @override
  State<MenuNavegacion> createState() => _MenuNavegacionState();
}

class _MenuNavegacionState extends State<MenuNavegacion> {
  int indiceSeleccionado = 0;

  final List<Widget> pantallas = const [Inicio(), EstadisticasScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: indiceSeleccionado, children: pantallas),
      bottomNavigationBar: NavigationBar(
        height: 50,
        elevation: 0,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: indiceSeleccionado,
        onDestinationSelected: (indice) {
          setState(() {
            indiceSeleccionado = indice;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.work_outline, color: context.colors.textSecondary),
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
    );
  }
}
