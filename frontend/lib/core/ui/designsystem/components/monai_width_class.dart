import 'package:flutter/widgets.dart';

/// Material window-size breakpoints: phone, tablet portrait, tablet
/// landscape. Picks the navigation layout and one or two panes.
enum MonAIWidthClass {
  /// Under 600: bottom bar, one pane.
  compact,

  /// 600 to 839: navigation rail.
  medium,

  /// 840 and up: permanent drawer, two panes.
  expanded;

  /// The class for a window [width] in logical pixels.
  static MonAIWidthClass of(double width) => switch (width) {
    >= 840 => expanded,
    >= 600 => medium,
    _ => compact,
  };
}

/// The width class of the current window.
extension MonAIWidthClassX on BuildContext {
  /// The [MonAIWidthClass] for this context's window width.
  MonAIWidthClass get widthClass =>
      MonAIWidthClass.of(MediaQuery.sizeOf(this).width);
}
