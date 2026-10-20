import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'package:monai/core/designsystem/theme/monai_palette.dart';
import 'package:monai/core/model/wallet_type.dart';

/// Category colors.
///
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

  /// Slate, used when a category has no color.
  static const fallback = Color(0xFF64748B);

  /// The icon color for [color] in the current theme.
  static Color content(Color color, {required bool dark}) =>
      switch (dark ? _darkVariants[color.toARGB32()] : null) {
        final int argb => Color(argb),
        null => color,
      };

  /// The circle behind a category icon.
  static Color tint(Color color, {required bool dark}) =>
      color.withValues(alpha: dark ? 0.20 : 0.12);

  /// Parses `#RRGGBB`; returns [fallback] for null or malformed input.
  static Color parse(String? hex) {
    final digits = hex?.startsWith('#') ?? false ? hex!.substring(1) : hex;
    if (digits == null || digits.length != 6) return fallback;
    final value = int.tryParse(digits, radix: 16);
    return value == null ? fallback : Color(0xFF000000 | value);
  }
}

/// A wallet card gradient: [start] → [end], with [muted] for secondary text.
@immutable
class WalletGradient {
  /// Creates a wallet gradient.
  const WalletGradient(this.start, this.end, this.muted);

  /// The darker, top-left color.
  final Color start;

  /// The brighter, bottom-right color.
  final Color end;

  /// Secondary text on the card ("Bank · balance").
  final Color muted;

  /// The card's background.
  LinearGradient get gradient =>
      LinearGradient(begin: .topLeft, end: .bottomRight, colors: [start, end]);
}

/// Wallet card gradients by wallet type, light and dark.
abstract final class WalletGradients {
  /// The card of a wallet with the stored [colorHex], else its [type]'s.
  static WalletGradient of(
    WalletType type, {
    required bool dark,
    String? colorHex,
  }) =>
      WalletColor.fromHex(colorHex)?.gradient(dark: dark) ??
      forType(type, dark: dark);

  /// The [type]'s own card, for a wallet without a color of its own.
  static WalletGradient forType(WalletType type, {required bool dark}) =>
      switch (type) {
        .bank => bank(dark: dark),
        .eWallet => eWallet(dark: dark),
        .cash => cash(dark: dark),
        .other => bankAlt(dark: dark),
      };

  /// Bank wallets (indigo).
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

  /// A second, deeper indigo for a user-picked indigo card.
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

  /// E-wallets (cyan).
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

  /// Cash wallets (green).
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

/// The card colors a user can pick for a wallet.
///
/// The server stores [hex], the bright end of the gradient; a wallet without
/// a color, or with one the app doesn't know, uses its type's gradient.
enum WalletColor {
  indigo('#4A45D6'),
  teal('#0891B2'),
  green('#079455'),
  violet('#7C3AED'),
  rose('#E11D48'),
  slate('#475467');

  const WalletColor(this.hex);

  /// The value the server stores.
  final String hex;

  /// The card gradient for this color.
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

  /// The color stored as [hex] (case-insensitive), or null if unknown.
  static WalletColor? fromHex(String? hex) {
    final wanted = hex?.toUpperCase();
    return values.where((c) => c.hex == wanted).firstOrNull;
  }
}
