import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';

class ReportSkeleton extends StatelessWidget {
  const ReportSkeleton({super.key});

  static const _tileHeight = 76.0;
  static const _netHeight = 72.0;
  static const _breakdownHeight = 360.0;
  static const _budgetHeight = 96.0;

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x2,
      children: [
        Row(
          spacing: MonAISpacing.x2,
          children: [
            Expanded(
              child: MonAISkeleton(
                height: _tileHeight,
                borderRadius: MonAIRadius.lgAll,
              ),
            ),
            Expanded(
              child: MonAISkeleton(
                height: _tileHeight,
                borderRadius: MonAIRadius.lgAll,
              ),
            ),
          ],
        ),
        MonAISkeleton(height: _netHeight, borderRadius: MonAIRadius.lgAll),
        SizedBox(height: MonAISpacing.x2),
        MonAISkeleton(
          height: _breakdownHeight,
          borderRadius: MonAIRadius.lgAll,
        ),
        SizedBox(height: MonAISpacing.x2),
        MonAISkeleton(height: _budgetHeight, borderRadius: MonAIRadius.lgAll),
      ],
    );
  }
}
