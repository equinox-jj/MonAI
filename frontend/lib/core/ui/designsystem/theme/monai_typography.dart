import 'package:flutter/material.dart';

const kMonAIFontFamily = 'PlusJakartaSans';

/// The font is variable, so the weight is set both as [FontWeight] and as the
/// `wght` axis.
TextStyle _style(
  double size,
  double height,
  FontWeight weight, {
  double letterSpacing = 0,
}) {
  return TextStyle(
    fontFamily: kMonAIFontFamily,
    fontSize: size,
    height: height / size,
    fontWeight: weight,
    fontVariations: [FontVariation.weight(weight.value.toDouble())],
    letterSpacing: letterSpacing,
    leadingDistribution: .even,
  );
}

extension MonAITextStyleX on TextStyle {
  /// Use this instead of `copyWith(fontWeight: ...)`, which leaves the variable
  /// font's `wght` axis at the old weight.
  TextStyle withWeight(FontWeight weight) => copyWith(
    fontWeight: weight,
    fontVariations: [FontVariation.weight(weight.value.toDouble())],
  );

  TextStyle get tabular =>
      copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
}

/// The design's type scale mapped onto Material slots:
///
/// | Slot           | Size/line | Use                                     |
/// |----------------|-----------|-----------------------------------------|
/// | displayLarge   | 40/48 B   | Amount being entered                    |
/// | displayMedium  | 36/44 B   | Total balance hero                      |
/// | displaySmall   | 32/40 B   | Onboarding headline, transaction amount |
/// | headlineLarge  | 28/36 B   | Auth titles, wallet balance             |
/// | headlineMedium | 24/32 B   | Tab screen titles                       |
/// | headlineSmall  | 20/28 SB  | Section headings, sheet/dialog titles   |
/// | titleLarge     | 18/26 SB  | Top bar title, profile name             |
/// | titleMedium    | 16/24 SB  | List and card titles, large buttons     |
/// | titleSmall     | 15/22 M   | Settings rows                           |
/// | bodyLarge      | 16/24 R   | Inputs, paragraphs                      |
/// | bodyMedium     | 14/20 R   | Supporting copy                         |
/// | bodySmall      | 12/16 R   | Meta lines, helper text                 |
/// | labelLarge     | 14/20 SB  | Medium buttons, links                   |
/// | labelMedium    | 12/16 SB  | Field labels, chips, small buttons      |
/// | labelSmall     | 11/16 SB  | Nav labels, badges                      |
final monAITextTheme = TextTheme(
  displayLarge: _style(40, 48, .w700, letterSpacing: -0.5),
  displayMedium: _style(36, 44, .w700, letterSpacing: -0.5),
  displaySmall: _style(32, 40, .w700, letterSpacing: -0.5),
  headlineLarge: _style(28, 36, .w700, letterSpacing: -0.25),
  headlineMedium: _style(24, 32, .w700, letterSpacing: -0.25),
  headlineSmall: _style(20, 28, .w600),
  titleLarge: _style(18, 26, .w600),
  titleMedium: _style(16, 24, .w600),
  titleSmall: _style(15, 22, .w500),
  bodyLarge: _style(16, 24, .w400),
  bodyMedium: _style(14, 20, .w400),
  bodySmall: _style(12, 16, .w400),
  labelLarge: _style(14, 20, .w600),
  labelMedium: _style(12, 16, .w600),
  labelSmall: _style(11, 16, .w600),
);

@immutable
class MonAITextStyles extends ThemeExtension<MonAITextStyles> {
  /// Use [standard] instead of calling this.
  const MonAITextStyles({
    required this.amountLarge,
    required this.amountMedium,
    required this.amount,
    required this.bodyCompact,
    required this.overline,
  });

  static final standard = MonAITextStyles(
    amountLarge: _style(28, 36, .w700).tabular,
    amountMedium: _style(20, 28, .w700).tabular,
    amount: _style(16, 24, .w600).tabular,
    bodyCompact: _style(13, 18, .w400),
    overline: _style(12, 16, .w600, letterSpacing: 0.4),
  );

  final TextStyle amountLarge;
  final TextStyle amountMedium;
  final TextStyle amount;
  final TextStyle bodyCompact;

  /// Uppercase the text yourself.
  final TextStyle overline;

  @override
  MonAITextStyles copyWith({
    TextStyle? amountLarge,
    TextStyle? amountMedium,
    TextStyle? amount,
    TextStyle? bodyCompact,
    TextStyle? overline,
  }) {
    return MonAITextStyles(
      amountLarge: amountLarge ?? this.amountLarge,
      amountMedium: amountMedium ?? this.amountMedium,
      amount: amount ?? this.amount,
      bodyCompact: bodyCompact ?? this.bodyCompact,
      overline: overline ?? this.overline,
    );
  }

  @override
  MonAITextStyles lerp(MonAITextStyles? other, double t) {
    if (other == null) return this;
    return MonAITextStyles(
      amountLarge: TextStyle.lerp(amountLarge, other.amountLarge, t)!,
      amountMedium: TextStyle.lerp(amountMedium, other.amountMedium, t)!,
      amount: TextStyle.lerp(amount, other.amount, t)!,
      bodyCompact: TextStyle.lerp(bodyCompact, other.bodyCompact, t)!,
      overline: TextStyle.lerp(overline, other.overline, t)!,
    );
  }
}
