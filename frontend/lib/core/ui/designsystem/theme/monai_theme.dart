import 'package:flutter/material.dart';

import 'package:monai/core/ui/designsystem/theme/monai_colors.dart';
import 'package:monai/core/ui/designsystem/theme/monai_radius.dart';
import 'package:monai/core/ui/designsystem/theme/monai_sizes.dart';
import 'package:monai/core/ui/designsystem/theme/monai_spacing.dart';
import 'package:monai/core/ui/designsystem/theme/monai_typography.dart';

/// No dynamic color: the design is brand-colored in both modes.
abstract final class MonAITheme {
  static ThemeData light() => _build(MonAIColors.light);

  static ThemeData dark() => _build(MonAIColors.dark);

  static ThemeData _build(MonAIColors c) {
    final textTheme = monAITextTheme.apply(
      bodyColor: c.textPrimary,
      displayColor: c.textPrimary,
    );
    const inputBorderRadius = MonAIRadius.mdAll;
    OutlineInputBorder inputBorder(Color color, double width) =>
        OutlineInputBorder(
          borderRadius: inputBorderRadius,
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: c.isDark ? .dark : .light,
      colorScheme: _colorScheme(c),
      scaffoldBackgroundColor: c.background,
      canvasColor: c.background,
      fontFamily: kMonAIFontFamily,
      textTheme: textTheme,
      extensions: [c, MonAITextStyles.standard],
      splashFactory: InkSparkle.splashFactory,
      iconTheme: IconThemeData(color: c.iconStrong, size: MonAISizes.icon),
      dividerTheme: DividerThemeData(
        color: c.divider,
        thickness: MonAISizes.border,
        space: MonAISizes.border,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        foregroundColor: c.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: .zero,
        shape: RoundedRectangleBorder(
          borderRadius: MonAIRadius.lgAll,
          side: BorderSide(color: c.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surfaceSunken,
        hintStyle: textTheme.bodyLarge?.copyWith(color: c.textDisabled),
        contentPadding: const .symmetric(
          horizontal: MonAISpacing.x3_5,
          vertical: MonAISpacing.x4,
        ),
        border: inputBorder(c.border, MonAISizes.border),
        enabledBorder: inputBorder(c.border, MonAISizes.border),
        focusedBorder: inputBorder(c.focus, MonAISizes.borderFocused),
        errorBorder: inputBorder(c.error, MonAISizes.borderFocused),
        focusedErrorBorder: inputBorder(c.error, MonAISizes.borderFocused),
        disabledBorder: inputBorder(c.border, MonAISizes.border),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: c.focus,
        selectionColor: c.focus.withValues(alpha: 0.24),
        selectionHandleColor: c.focus,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        modalBackgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        modalBarrierColor: c.scrim,
        shape: const RoundedRectangleBorder(borderRadius: MonAIRadius.sheetTop),
        showDragHandle: false,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        barrierColor: c.scrim,
        shape: const RoundedRectangleBorder(borderRadius: MonAIRadius.xxlAll),
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: c.textSecondary,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: c.onInverseSurface,
        ),
        actionTextColor: c.inverseAccent,
        behavior: .floating,
        elevation: 12,
        shape: const RoundedRectangleBorder(borderRadius: MonAIRadius.mdAll),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.accent,
        linearTrackColor: c.surfaceSunken,
        circularTrackColor: c.surfaceSunken,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: c.onPrimary,
          disabledBackgroundColor: c.disabledContainer,
          disabledForegroundColor: c.disabledContent,
          minimumSize: const Size(
            MonAISizes.touchTarget,
            MonAISizes.buttonLarge,
          ),
          shape: const StadiumBorder(),
          textStyle: textTheme.titleMedium,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.accent,
          textStyle: textTheme.labelLarge,
          shape: const RoundedRectangleBorder(borderRadius: MonAIRadius.smAll),
        ),
      ),
    );
  }

  static ColorScheme _colorScheme(MonAIColors c) {
    final base = c.isDark
        ? const ColorScheme.dark()
        : const ColorScheme.light();
    return base.copyWith(
      primary: c.primary,
      onPrimary: c.onPrimary,
      primaryContainer: c.primaryContainer,
      onPrimaryContainer: c.onPrimaryContainer,
      inversePrimary: c.inverseAccent,
      secondary: c.accent,
      onSecondary: c.onPrimary,
      secondaryContainer: c.primaryContainer,
      onSecondaryContainer: c.onPrimaryContainer,
      tertiary: c.highlight,
      onTertiary: c.onHighlight,
      surface: c.surface,
      onSurface: c.textPrimary,
      onSurfaceVariant: c.textSecondary,
      surfaceTint: c.surface,
      surfaceBright: c.surface,
      surfaceDim: c.background,
      surfaceContainerLowest: c.surface,
      surfaceContainerLow: c.surface,
      surfaceContainer: c.surface,
      surfaceContainerHigh: c.surface,
      surfaceContainerHighest: c.surfaceSunken,
      inverseSurface: c.inverseSurface,
      onInverseSurface: c.onInverseSurface,
      error: c.error,
      onError: c.onPrimary,
      errorContainer: c.errorContainer,
      onErrorContainer: c.onErrorContainer,
      outline: c.borderStrong,
      outlineVariant: c.border,
      scrim: c.scrim,
    );
  }
}
