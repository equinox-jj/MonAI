import 'package:flutter/widgets.dart';

enum MonAIWidthClass {
  compact,
  medium,
  expanded;

  static MonAIWidthClass of(double width) => switch (width) {
    >= 840 => expanded,
    >= 600 => medium,
    _ => compact,
  };
}

extension MonAIWidthClassX on BuildContext {
  MonAIWidthClass get widthClass =>
      MonAIWidthClass.of(MediaQuery.sizeOf(this).width);
}
