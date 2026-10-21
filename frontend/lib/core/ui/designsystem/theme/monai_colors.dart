import 'package:flutter/material.dart';

import 'package:monai/core/ui/designsystem/theme/monai_palette.dart';

/// Read with `context.colors`. Naming: `text*` for foreground copy, `surface*`
/// for fills, `border*` for strokes, and paired `x` / `xContainer` /
/// `onXContainer` for status colors.
@immutable
class MonAIColors extends ThemeExtension<MonAIColors> {
  /// Use [light] or [dark] instead of calling this.
  const MonAIColors({
    required this.isDark,
    required this.primary,
    required this.onPrimary,
    required this.accent,
    required this.focus,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.primaryContainerBorder,
    required this.highlight,
    required this.onHighlight,
    required this.onGradientMuted,
    required this.heroGradientStart,
    required this.heroGradientEnd,
    required this.background,
    required this.surface,
    required this.surfaceSunken,
    required this.surfaceKey,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.inverseAccent,
    required this.scrim,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.iconStrong,
    required this.border,
    required this.borderStrong,
    required this.divider,
    required this.expense,
    required this.expenseContainer,
    required this.income,
    required this.incomeContainer,
    required this.transfer,
    required this.error,
    required this.errorText,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.errorContainerBorder,
    required this.success,
    required this.successText,
    required this.warning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.warningContainerBorder,
    required this.disabledContainer,
    required this.disabledContent,
  });

  static final light = MonAIColors(
    isDark: false,
    primary: MonAIPalette.indigo600,
    onPrimary: MonAIPalette.white,
    accent: MonAIPalette.indigo600,
    focus: MonAIPalette.indigo500,
    primaryContainer: MonAIPalette.indigo50,
    onPrimaryContainer: MonAIPalette.indigo700,
    primaryContainerBorder: MonAIPalette.indigo200,
    highlight: MonAIPalette.lime,
    onHighlight: MonAIPalette.indigo950,
    onGradientMuted: MonAIPalette.indigo100,
    heroGradientStart: MonAIPalette.indigo700,
    heroGradientEnd: MonAIPalette.indigo500,
    background: MonAIPalette.gray50,
    surface: MonAIPalette.white,
    surfaceSunken: MonAIPalette.gray100,
    surfaceKey: MonAIPalette.gray50,
    inverseSurface: MonAIPalette.gray900,
    onInverseSurface: MonAIPalette.white,
    inverseAccent: MonAIPalette.indigo300,
    scrim: MonAIPalette.gray900.withValues(alpha: 0.48),
    textPrimary: MonAIPalette.gray900,
    textSecondary: MonAIPalette.gray600,
    textTertiary: MonAIPalette.gray500,
    textDisabled: MonAIPalette.gray400,
    iconStrong: MonAIPalette.gray700,
    border: MonAIPalette.gray200,
    borderStrong: MonAIPalette.gray300,
    divider: MonAIPalette.gray100,
    expense: MonAIPalette.red600,
    expenseContainer: MonAIPalette.red50,
    income: MonAIPalette.green600,
    incomeContainer: MonAIPalette.green50,
    transfer: MonAIPalette.gray900,
    error: MonAIPalette.red600,
    errorText: MonAIPalette.red700,
    errorContainer: MonAIPalette.red50,
    onErrorContainer: MonAIPalette.red900,
    errorContainerBorder: MonAIPalette.red200,
    success: MonAIPalette.green600,
    successText: MonAIPalette.green700,
    warning: MonAIPalette.amber600,
    warningContainer: MonAIPalette.amber50,
    onWarningContainer: MonAIPalette.amber900,
    warningContainerBorder: MonAIPalette.amber200,
    disabledContainer: MonAIPalette.gray200,
    disabledContent: MonAIPalette.gray400,
  );

  static final dark = MonAIColors(
    isDark: true,
    primary: MonAIPalette.indigo600,
    onPrimary: MonAIPalette.white,
    accent: MonAIPalette.indigo300,
    focus: MonAIPalette.indigo300,
    primaryContainer: MonAIPalette.indigo900,
    onPrimaryContainer: MonAIPalette.indigo200,
    primaryContainerBorder: MonAIPalette.indigo800,
    highlight: MonAIPalette.lime,
    onHighlight: MonAIPalette.indigo950,
    onGradientMuted: MonAIPalette.indigo100,
    heroGradientStart: MonAIPalette.indigo800,
    heroGradientEnd: MonAIPalette.indigo600,
    background: MonAIPalette.gray925,
    surface: MonAIPalette.gray900,
    surfaceSunken: MonAIPalette.gray950,
    surfaceKey: MonAIPalette.gray800,
    inverseSurface: MonAIPalette.gray50,
    onInverseSurface: MonAIPalette.gray900,
    inverseAccent: MonAIPalette.indigo600,
    scrim: MonAIPalette.gray950.withValues(alpha: 0.64),
    textPrimary: MonAIPalette.gray50,
    textSecondary: MonAIPalette.gray300,
    textTertiary: MonAIPalette.gray400,
    textDisabled: MonAIPalette.gray500,
    iconStrong: MonAIPalette.gray300,
    border: MonAIPalette.gray800,
    borderStrong: MonAIPalette.gray700,
    divider: MonAIPalette.gray800,
    expense: MonAIPalette.red400,
    expenseContainer: MonAIPalette.red600.withValues(alpha: 0.20),
    income: MonAIPalette.green400,
    incomeContainer: MonAIPalette.green600.withValues(alpha: 0.22),
    transfer: MonAIPalette.gray50,
    error: MonAIPalette.red400,
    errorText: MonAIPalette.red400,
    errorContainer: MonAIPalette.red600.withValues(alpha: 0.16),
    onErrorContainer: MonAIPalette.red200,
    errorContainerBorder: MonAIPalette.red600.withValues(alpha: 0.40),
    success: MonAIPalette.green400,
    successText: MonAIPalette.green400,
    warning: MonAIPalette.amber400,
    warningContainer: MonAIPalette.amber600.withValues(alpha: 0.16),
    onWarningContainer: MonAIPalette.amber200,
    warningContainerBorder: MonAIPalette.amber600.withValues(alpha: 0.40),
    disabledContainer: MonAIPalette.gray800,
    disabledContent: MonAIPalette.gray500,
  );

  final bool isDark;

  // Brand

  final Color primary;

  final Color onPrimary;
  final Color accent;
  final Color focus;

  final Color primaryContainer;

  final Color onPrimaryContainer;
  final Color primaryContainerBorder;
  final Color highlight;

  final Color onHighlight;
  final Color onGradientMuted;

  final Color heroGradientStart;

  final Color heroGradientEnd;

  // Surfaces

  final Color background;

  final Color surface;
  final Color surfaceSunken;
  final Color surfaceKey;
  final Color inverseSurface;

  final Color onInverseSurface;
  final Color inverseAccent;

  final Color scrim;

  // Text

  final Color textPrimary;

  final Color textSecondary;

  final Color textTertiary;
  final Color textDisabled;
  final Color iconStrong;

  // Strokes

  final Color border;

  final Color borderStrong;

  final Color divider;

  // Money

  final Color expense;

  final Color expenseContainer;

  final Color income;

  final Color incomeContainer;

  final Color transfer;

  // Status

  final Color error;

  final Color errorText;

  final Color errorContainer;

  final Color onErrorContainer;

  final Color errorContainerBorder;

  final Color success;

  final Color successText;

  final Color warning;

  final Color warningContainer;

  final Color onWarningContainer;

  final Color warningContainerBorder;

  // Disabled controls

  final Color disabledContainer;

  final Color disabledContent;

  LinearGradient get heroGradient => LinearGradient(
    begin: .topLeft,
    end: .bottomRight,
    colors: [heroGradientStart, heroGradientEnd],
  );

  @override
  MonAIColors copyWith({
    bool? isDark,
    Color? primary,
    Color? onPrimary,
    Color? accent,
    Color? focus,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? primaryContainerBorder,
    Color? highlight,
    Color? onHighlight,
    Color? onGradientMuted,
    Color? heroGradientStart,
    Color? heroGradientEnd,
    Color? background,
    Color? surface,
    Color? surfaceSunken,
    Color? surfaceKey,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? inverseAccent,
    Color? scrim,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textDisabled,
    Color? iconStrong,
    Color? border,
    Color? borderStrong,
    Color? divider,
    Color? expense,
    Color? expenseContainer,
    Color? income,
    Color? incomeContainer,
    Color? transfer,
    Color? error,
    Color? errorText,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? errorContainerBorder,
    Color? success,
    Color? successText,
    Color? warning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? warningContainerBorder,
    Color? disabledContainer,
    Color? disabledContent,
  }) {
    return MonAIColors(
      isDark: isDark ?? this.isDark,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      accent: accent ?? this.accent,
      focus: focus ?? this.focus,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      primaryContainerBorder:
          primaryContainerBorder ?? this.primaryContainerBorder,
      highlight: highlight ?? this.highlight,
      onHighlight: onHighlight ?? this.onHighlight,
      onGradientMuted: onGradientMuted ?? this.onGradientMuted,
      heroGradientStart: heroGradientStart ?? this.heroGradientStart,
      heroGradientEnd: heroGradientEnd ?? this.heroGradientEnd,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceSunken: surfaceSunken ?? this.surfaceSunken,
      surfaceKey: surfaceKey ?? this.surfaceKey,
      inverseSurface: inverseSurface ?? this.inverseSurface,
      onInverseSurface: onInverseSurface ?? this.onInverseSurface,
      inverseAccent: inverseAccent ?? this.inverseAccent,
      scrim: scrim ?? this.scrim,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      iconStrong: iconStrong ?? this.iconStrong,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      divider: divider ?? this.divider,
      expense: expense ?? this.expense,
      expenseContainer: expenseContainer ?? this.expenseContainer,
      income: income ?? this.income,
      incomeContainer: incomeContainer ?? this.incomeContainer,
      transfer: transfer ?? this.transfer,
      error: error ?? this.error,
      errorText: errorText ?? this.errorText,
      errorContainer: errorContainer ?? this.errorContainer,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
      errorContainerBorder: errorContainerBorder ?? this.errorContainerBorder,
      success: success ?? this.success,
      successText: successText ?? this.successText,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      warningContainerBorder:
          warningContainerBorder ?? this.warningContainerBorder,
      disabledContainer: disabledContainer ?? this.disabledContainer,
      disabledContent: disabledContent ?? this.disabledContent,
    );
  }

  @override
  MonAIColors lerp(MonAIColors? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return MonAIColors(
      isDark: t < 0.5 ? isDark : other.isDark,
      primary: mix(primary, other.primary),
      onPrimary: mix(onPrimary, other.onPrimary),
      accent: mix(accent, other.accent),
      focus: mix(focus, other.focus),
      primaryContainer: mix(primaryContainer, other.primaryContainer),
      onPrimaryContainer: mix(onPrimaryContainer, other.onPrimaryContainer),
      primaryContainerBorder: mix(
        primaryContainerBorder,
        other.primaryContainerBorder,
      ),
      highlight: mix(highlight, other.highlight),
      onHighlight: mix(onHighlight, other.onHighlight),
      onGradientMuted: mix(onGradientMuted, other.onGradientMuted),
      heroGradientStart: mix(heroGradientStart, other.heroGradientStart),
      heroGradientEnd: mix(heroGradientEnd, other.heroGradientEnd),
      background: mix(background, other.background),
      surface: mix(surface, other.surface),
      surfaceSunken: mix(surfaceSunken, other.surfaceSunken),
      surfaceKey: mix(surfaceKey, other.surfaceKey),
      inverseSurface: mix(inverseSurface, other.inverseSurface),
      onInverseSurface: mix(onInverseSurface, other.onInverseSurface),
      inverseAccent: mix(inverseAccent, other.inverseAccent),
      scrim: mix(scrim, other.scrim),
      textPrimary: mix(textPrimary, other.textPrimary),
      textSecondary: mix(textSecondary, other.textSecondary),
      textTertiary: mix(textTertiary, other.textTertiary),
      textDisabled: mix(textDisabled, other.textDisabled),
      iconStrong: mix(iconStrong, other.iconStrong),
      border: mix(border, other.border),
      borderStrong: mix(borderStrong, other.borderStrong),
      divider: mix(divider, other.divider),
      expense: mix(expense, other.expense),
      expenseContainer: mix(expenseContainer, other.expenseContainer),
      income: mix(income, other.income),
      incomeContainer: mix(incomeContainer, other.incomeContainer),
      transfer: mix(transfer, other.transfer),
      error: mix(error, other.error),
      errorText: mix(errorText, other.errorText),
      errorContainer: mix(errorContainer, other.errorContainer),
      onErrorContainer: mix(onErrorContainer, other.onErrorContainer),
      errorContainerBorder: mix(
        errorContainerBorder,
        other.errorContainerBorder,
      ),
      success: mix(success, other.success),
      successText: mix(successText, other.successText),
      warning: mix(warning, other.warning),
      warningContainer: mix(warningContainer, other.warningContainer),
      onWarningContainer: mix(onWarningContainer, other.onWarningContainer),
      warningContainerBorder: mix(
        warningContainerBorder,
        other.warningContainerBorder,
      ),
      disabledContainer: mix(disabledContainer, other.disabledContainer),
      disabledContent: mix(disabledContent, other.disabledContent),
    );
  }
}
