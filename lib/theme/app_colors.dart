import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color background;
  final Color backgroundTransparent;
  final Color shadow;
  final Color mainColor;
  final Color danger;
  final Color textPrimary;
  final Color textSecondary;
  final Color inputBackground;
  final Color inputFocusedBorder;

  const AppColors({
    required this.background,
    required this.backgroundTransparent,
    required this.shadow,
    required this.mainColor,
    required this.danger,
    required this.textPrimary,
    required this.textSecondary,
    required this.inputBackground,
    required this.inputFocusedBorder,
  });

  static const light = AppColors(
    mainColor: Color.fromARGB(255, 20, 17, 222),
    background: Colors.white,
    backgroundTransparent: Color.fromRGBO(255, 255, 255, 0.4),
    shadow: Color.fromRGBO(0, 0, 0, 0.07),
    danger: Colors.red,
    textPrimary: Color.fromRGBO(15, 23, 42, 1),
    textSecondary: Color.fromRGBO(100, 116, 139, 1),
    inputBackground: Color.fromRGBO(241, 245, 249, 1),
    inputFocusedBorder: Color.fromRGBO(203, 213, 225, 1),
  );

  static final dark = AppColors(
    mainColor: aclarar(light.mainColor, 0.15), // más claro para contrastar
    background: Color.fromRGBO(15, 23, 42, 1),
    backgroundTransparent: Color.fromRGBO(15, 23, 42, 0.4),
    shadow: Color.fromRGBO(0, 0, 0, 0.4),
    danger: Color.fromRGBO(239, 83, 80, 1),
    textPrimary: Color.fromRGBO(241, 245, 249, 1),
    textSecondary: Color.fromRGBO(148, 163, 184, 1),
    inputBackground: Color.fromRGBO(30, 41, 59, 0.8),
    inputFocusedBorder: Color.fromRGBO(71, 85, 105, 1),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? backgroundTransparent,
    Color? shadow,
    Color? mainColor,
    Color? danger,
    Color? textPrimary,
    Color? textSecondary,
    Color? inputBackground,
    Color? inputFocusedBorder,
  }) {
    return AppColors(
      background: background ?? this.background,
      backgroundTransparent:
          backgroundTransparent ?? this.backgroundTransparent,
      shadow: shadow ?? this.shadow,
      mainColor: mainColor ?? this.mainColor,
      danger: danger ?? this.danger,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      inputBackground: inputBackground ?? this.inputBackground,
      inputFocusedBorder: inputFocusedBorder ?? this.inputFocusedBorder,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      backgroundTransparent: Color.lerp(
        backgroundTransparent,
        other.backgroundTransparent,
        t,
      )!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      mainColor: Color.lerp(mainColor, other.mainColor, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t)!,
      inputFocusedBorder: Color.lerp(
        inputFocusedBorder,
        other.inputFocusedBorder,
        t,
      )!,
    );
  }
}

// Atajo: context.colors.mainColor
extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

Color aclarar(Color c, [double cantidad = 0.15]) {
  final hsl = HSLColor.fromColor(c);
  return hsl
      .withLightness((hsl.lightness + cantidad).clamp(0.0, 1.0))
      .withSaturation((hsl.saturation * 0.9).clamp(0.0, 1.0))
      .toColor();
}
