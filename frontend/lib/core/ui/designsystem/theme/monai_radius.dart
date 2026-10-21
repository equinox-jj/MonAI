import 'package:flutter/painting.dart';

/// Corner radii, as raw values and ready-made [BorderRadius]es.
abstract final class MonAIRadius {
  /// Tags like "ADMIN" and "DEFAULT", progress bars, skeletons.
  static const double xs = 4;

  /// Filter chips, receipt thumbnail, text links.
  static const double sm = 8;

  /// Inputs, banners, snackbars, small stat cards.
  static const double md = 12;

  /// Picker options.
  static const double mdl = 14;

  /// Cards, wallet cards, number-pad keys.
  static const double lg = 16;

  /// App logo tile.
  static const double xl = 18;

  /// Balance hero, sheets, dialogs.
  static const double xxl = 24;

  /// Onboarding hero panel.
  static const double xxxl = 32;

  /// Pills and circles.
  static const double full = 999;

  /// [xs] on every corner.
  static const xsAll = BorderRadius.all(Radius.circular(xs));

  /// [sm] on every corner.
  static const smAll = BorderRadius.all(Radius.circular(sm));

  /// [md] on every corner.
  static const mdAll = BorderRadius.all(Radius.circular(md));

  /// [mdl] on every corner.
  static const mdlAll = BorderRadius.all(Radius.circular(mdl));

  /// [lg] on every corner.
  static const lgAll = BorderRadius.all(Radius.circular(lg));

  /// [xl] on every corner.
  static const xlAll = BorderRadius.all(Radius.circular(xl));

  /// [xxl] on every corner.
  static const xxlAll = BorderRadius.all(Radius.circular(xxl));

  /// [xxxl] on every corner.
  static const xxxlAll = BorderRadius.all(Radius.circular(xxxl));

  /// Fully rounded ends.
  static const fullAll = BorderRadius.all(Radius.circular(full));

  /// [xxl] top corners, for bottom sheets.
  static const sheetTop = BorderRadius.vertical(top: Radius.circular(xxl));
}
