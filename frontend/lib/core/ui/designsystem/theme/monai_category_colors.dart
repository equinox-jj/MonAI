import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'package:monai/core/ui/designsystem/theme/monai_palette.dart';
import 'package:monai/core/model/wallet_type.dart';

/// The server stores the light hex (`#F97316`); dark mode swaps it for a
/// lighter shade so it reads on dark surfaces. Unknown colors are used as-is.
abstract final class CategoryColors {
  /// Light ARGB → dark ARGB. Keyed by int because a const map can't key on
  /// [Color].
  static const _darkVariants = <int, int>{
    0xFFF97316: 0xFFFB923C, // orange (Food)
    0xFF0EA5E9: 0xFF38BDF8, // sky (Transport)
    0xFF8B5CF6: 0xFFA78BFA, // violet (Bills)
    0xFFEC4899: 0xFFF472B6, // pink (Shopping)
    0xFF10B981: 0xFF34D399, // emerald (Health)
    0xFFF59E0B: 0xFFFBBF24, // amber (Entertainment)
    0xFF64748B: 0xFF94A3B8, // slate (Other)
    0xFF14B8A6: 0xFF2DD4BF, // teal (Salary)
    0xFF84CC16: 0xFFA3E635, // lime (Bonus)
    0xFF6366F1: 0xFF818CF8, // indigo
  };

  static const fallback = Color(0xFF64748B);

  static Color content(Color color, {required bool dark}) =>
      switch (dark ? _darkVariants[color.toARGB32()] : null) {
        final int argb => Color(argb),
        null => color,
      };

  static Color tint(Color color, {required bool dark}) =>
      color.withValues(alpha: dark ? 0.20 : 0.12);

  static Color parse(String? hex) {
    final digits = hex?.startsWith('#') ?? false ? hex!.substring(1) : hex;
    if (digits == null || digits.length != 6) return fallback;
    final value = int.tryParse(digits, radix: 16);
    return value == null ? fallback : Color(0xFF000000 | value);
  }
}

@immutable
class WalletGradient {
  const WalletGradient(this.start, this.end, this.muted);
  final Color start;
  final Color end;
  final Color muted;

  LinearGradient get gradient =>
      LinearGradient(begin: .topLeft, end: .bottomRight, colors: [start, end]);
}

abstract final class WalletGradients {
  static WalletGradient of(
    WalletType type, {
    required bool dark,
    String? colorHex,
  }) =>
      WalletColor.fromHex(colorHex)?.gradient(dark: dark) ??
      forType(type, dark: dark);

  static WalletGradient forType(WalletType type, {required bool dark}) =>
      switch (type) {
        .bank => bank(dark: dark),
        .eWallet => eWallet(dark: dark),
        .cash => cash(dark: dark),
        .other => bankAlt(dark: dark),
      };

  static WalletGradient bank({required bool dark}) => dark
      ? const WalletGradient(
          MonAIPalette.indigo800,
          MonAIPalette.indigo600,
          MonAIPalette.indigo100,
        )
      : const WalletGradient(
          MonAIPalette.indigo700,
          MonAIPalette.indigo500,
          MonAIPalette.indigo100,
        );

  static WalletGradient bankAlt({required bool dark}) => dark
      ? const WalletGradient(
          MonAIPalette.indigo850,
          MonAIPalette.indigo700,
          MonAIPalette.indigo100,
        )
      : const WalletGradient(
          MonAIPalette.indigo800,
          MonAIPalette.indigo600,
          MonAIPalette.indigo100,
        );

  static WalletGradient eWallet({required bool dark}) => dark
      ? const WalletGradient(
          MonAIPalette.cyan800,
          MonAIPalette.cyan700,
          MonAIPalette.cyan100,
        )
      : const WalletGradient(
          MonAIPalette.cyan700,
          MonAIPalette.cyan600,
          MonAIPalette.cyan100,
        );

  static WalletGradient cash({required bool dark}) => dark
      ? const WalletGradient(
          MonAIPalette.emerald800,
          MonAIPalette.green700,
          MonAIPalette.green50,
        )
      : const WalletGradient(
          MonAIPalette.green700,
          MonAIPalette.green600,
          MonAIPalette.green50,
        );
}

/// The server stores [hex], the bright end of the gradient. A wallet without
/// a color, or with one the app doesn't know, uses its type's gradient.
enum WalletColor {
  indigo('#4A45D6'),
  teal('#0891B2'),
  green('#079455'),
  violet('#7C3AED'),
  rose('#E11D48'),
  slate('#475467');

  const WalletColor(this.hex);
  final String hex;

  WalletGradient gradient({required bool dark}) => switch (this) {
    indigo => WalletGradients.bankAlt(dark: dark),
    teal => WalletGradients.eWallet(dark: dark),
    green => WalletGradients.cash(dark: dark),
    violet => const WalletGradient(
      MonAIPalette.violet800,
      MonAIPalette.violet600,
      MonAIPalette.violet100,
    ),
    rose => const WalletGradient(
      MonAIPalette.rose800,
      MonAIPalette.rose600,
      MonAIPalette.rose100,
    ),
    slate => const WalletGradient(
      MonAIPalette.gray800,
      MonAIPalette.gray600,
      MonAIPalette.gray100,
    ),
  };

  static WalletColor? fromHex(String? hex) {
    final wanted = hex?.toUpperCase();
    return values.where((c) => c.hex == wanted).firstOrNull;
  }
}
