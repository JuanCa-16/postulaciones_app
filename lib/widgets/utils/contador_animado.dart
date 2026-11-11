import 'package:flutter/material.dart';



class ContadorAnimado extends StatelessWidget {
  final num valor;
  final int decimales;
  final String sufijo;
  final TextStyle? style;

  final Duration duracion;
  final Curve curva;

  const ContadorAnimado({
    super.key,
    required this.valor,
    this.decimales = 0,
    this.sufijo = '',
    this.style,
    required this.duracion,
    required this.curva,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: valor.toDouble()),
      duration: duracion,
      curve: curva,
      builder: (context, v, _) =>
          Text('${v.toStringAsFixed(decimales)}$sufijo', style: style),
    );
  }
}
