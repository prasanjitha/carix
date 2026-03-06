import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  // Static color constants for Premium Dark theme
  static const Color primary = Color(0xFFE11D48); // Rose/Red
  static const Color accent = Color(0xFFF97316); // Orange
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color background = Color(0xFF0D1117);
  static const Color cyan = Color(0xFF2DD4BF);
  static const Color surface = Color(0xFF16213E);
  static const Color inputBackground = Color(0x14FFFFFF); // 0.05 opacity
  static const Color inputBorder = Color(0x33FFFFFF); // 0.2 opacity
  static const Color divider = Color(0x33FFFFFF); // 0.2 opacity

  // Static instances for Theme registration
  static const AppColors light = AppColors(
    textPrimaryColor: Colors.white,
    textSecondaryColor: Colors.white70,
    primaryLight: Color(0x1A2DD4BF),
    primaryColor: Color(0xFFE11D48),
    bgColor: Color(0xFF0D1117),
    surfceSecondary: Color(0xFF16213E),
    placeholder: Colors.white38,
    primaryDark: Color(0xFFE11D48),
    darkRed: Color(0xFFF06B6D),
    lightRed: Color(0xFFFFE0E1),
    primaryRed: Color(0xFFE11D48),
    errorRed: Color(0xFFE11D48),
    primaryLightBlue: Color(0xFF2DD4BF),
    inputFieldBackground: Color(0x0DFFFFFF),
    selectionCard: Color(0x1AFFFFFF),
    textMainBtn: Colors.white,
  );

  static const AppColors dark =
      light; // For now dark is same as premium light dark design

  // Instance fields for ThemeExtension
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final Color primaryLight;
  final Color primaryColor;
  final Color bgColor;
  final Color surfceSecondary;
  final Color? placeholder;
  final Color? primaryDark;
  final Color? darkRed;
  final Color? lightRed;
  final Color? primaryRed;
  final Color? errorRed;
  final Color? primaryLightBlue;
  final Color? inputFieldBackground;
  final Color? selectionCard;
  final Color? textMainBtn;

  const AppColors({
    required this.textPrimaryColor,
    required this.textSecondaryColor,
    required this.primaryLight,
    required this.primaryColor,
    required this.bgColor,
    required this.surfceSecondary,
    this.placeholder,
    this.primaryDark,
    this.darkRed,
    this.lightRed,
    this.primaryRed,
    this.errorRed,
    this.primaryLightBlue,
    this.inputFieldBackground,
    this.selectionCard,
    this.textMainBtn,
  });

  @override
  AppColors copyWith({
    Color? textPrimaryColor,
    Color? textSecondaryColor,
    Color? primaryLight,
    Color? primaryColor,
    Color? bgColor,
    Color? surfceSecondary,
    Color? placeholder,
    Color? primaryDark,
    Color? darkRed,
    Color? lightRed,
    Color? primaryRed,
    Color? errorRed,
    Color? primaryLightBlue,
    Color? inputFieldBackground,
    Color? selectionCard,
    Color? textMainBtn,
  }) {
    return AppColors(
      textPrimaryColor: textPrimaryColor ?? this.textPrimaryColor,
      textSecondaryColor: textSecondaryColor ?? this.textSecondaryColor,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryColor: primaryColor ?? this.primaryColor,
      bgColor: bgColor ?? this.bgColor,
      surfceSecondary: surfceSecondary ?? this.surfceSecondary,
      placeholder: placeholder ?? this.placeholder,
      primaryDark: primaryDark ?? this.primaryDark,
      darkRed: darkRed ?? this.darkRed,
      lightRed: lightRed ?? this.lightRed,
      primaryRed: primaryRed ?? this.primaryRed,
      errorRed: errorRed ?? this.errorRed,
      primaryLightBlue: primaryLightBlue ?? this.primaryLightBlue,
      inputFieldBackground: inputFieldBackground ?? this.inputFieldBackground,
      selectionCard: selectionCard ?? this.selectionCard,
      textMainBtn: textMainBtn ?? this.textMainBtn,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      textPrimaryColor: Color.lerp(
        textPrimaryColor,
        other.textPrimaryColor,
        t,
      )!,
      textSecondaryColor: Color.lerp(
        textSecondaryColor,
        other.textSecondaryColor,
        t,
      )!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      bgColor: Color.lerp(bgColor, other.bgColor, t)!,
      surfceSecondary: Color.lerp(surfceSecondary, other.surfceSecondary, t)!,
      placeholder: Color.lerp(placeholder, other.placeholder, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t),
      darkRed: Color.lerp(darkRed, other.darkRed, t),
      lightRed: Color.lerp(lightRed, other.lightRed, t),
      primaryRed: Color.lerp(primaryRed, other.primaryRed, t),
      errorRed: Color.lerp(errorRed, other.errorRed, t),
      primaryLightBlue: Color.lerp(primaryLightBlue, other.primaryLightBlue, t),
      inputFieldBackground: Color.lerp(
        inputFieldBackground,
        other.inputFieldBackground,
        t,
      ),
      selectionCard: Color.lerp(selectionCard, other.selectionCard, t),
      textMainBtn: Color.lerp(textMainBtn, other.textMainBtn, t),
    );
  }
}

extension AppThemeExtension on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
