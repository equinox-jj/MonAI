/// Spacing on a 2px grid, named by multiples of 4 (`x3` = 12).
///
/// The semantic aliases at the bottom cover the layouts the design repeats.
abstract final class MonAISpacing {
  static const double x0_5 = 2;
  static const double x1 = 4;
  static const double x1_5 = 6;
  static const double x2 = 8;
  static const double x2_5 = 10;
  static const double x3 = 12;
  static const double x3_5 = 14;
  static const double x4 = 16;
  static const double x5 = 20;
  static const double x6 = 24;
  static const double x8 = 32;
  static const double x10 = 40;

  /// Side padding of tab screens and full-screen forms.
  static const double screenHorizontal = x4;

  /// Side padding of auth, onboarding, sheets and dialogs.
  static const double screenHorizontalWide = x6;

  /// Top padding of tab screens.
  static const double screenTop = x6;

  /// Gap between Home sections.
  static const double sectionGap = x5;

  /// Gap between a section header and its content, and between Settings
  /// groups.
  static const double sectionContentGap = x3;

  /// Inner padding of cards.
  static const double cardPadding = x4;

  /// Label → input gap, and field → helper gap.
  static const double fieldLabelGap = x1_5;
}
