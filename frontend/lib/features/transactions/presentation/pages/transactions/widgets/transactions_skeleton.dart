import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';

/// Placeholder day groups while the first page loads. Read out as one
/// label.
class TransactionsSkeleton extends StatelessWidget {
  const TransactionsSkeleton({super.key});

  /// Two days of three and two rows.
  static const _groups = [
    [0.55, 0.40, 0.62],
    [0.48, 0.58],
  ];

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.transactionsLoading,
      excludeSemantics: true,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: .zero,
        itemCount: _groups.length,
        itemBuilder: (context, index) => _GroupSkeleton(rows: _groups[index]),
      ),
    );
  }
}

class _GroupSkeleton extends StatelessWidget {
  const _GroupSkeleton({required this.rows});

  /// Each row's title width, as a share of the row.
  final List<double> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        const Padding(
          padding: .fromLTRB(
            MonAISpacing.screenHorizontal,
            MonAISpacing.x3,
            MonAISpacing.screenHorizontal,
            MonAISpacing.x2,
          ),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              MonAISkeleton(height: 14, width: 140),
              MonAISkeleton(height: 14, width: 64),
            ],
          ),
        ),
        ColoredBox(
          color: context.colors.surface,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: .zero,
            itemCount: rows.length,
            itemBuilder: (context, index) => _RowSkeleton(width: rows[index]),
          ),
        ),
      ],
    );
  }
}

class _RowSkeleton extends StatelessWidget {
  const _RowSkeleton({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .all(MonAISpacing.x4),
      child: Row(
        spacing: MonAISpacing.x3,
        children: [
          const MonAISkeleton(
            height: MonAISizes.avatarMedium,
            width: MonAISizes.avatarMedium,
            borderRadius: MonAIRadius.fullAll,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: MonAISpacing.x1_5,
              children: [
                FractionallySizedBox(
                  widthFactor: width,
                  child: const MonAISkeleton(height: 14),
                ),
                const FractionallySizedBox(
                  widthFactor: 0.4,
                  child: MonAISkeleton(height: 10),
                ),
              ],
            ),
          ),
          const MonAISkeleton(height: 14, width: 72),
        ],
      ),
    );
  }
}
