import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:monai/core/ui/designsystem/theme/monai_theme.dart';

/// Pumps [child] inside a [MaterialApp] with the MonAI light theme.
Future<void> pumpThemed(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    MaterialApp(
      theme: MonAITheme.light(),
      home: Scaffold(body: Center(child: child)),
    ),
  );
}
