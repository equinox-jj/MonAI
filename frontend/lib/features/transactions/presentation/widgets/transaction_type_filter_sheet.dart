import 'package:flutter/material.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/model/transaction_type.dart';
import 'package:monai/features/transactions/presentation/model/transaction_text.dart';

/// All types, Expense, Income or Transfer; Apply sends the choice (null for
/// all) to [onApply] and closes. Show it with [showMonAIBottomSheet].
class TransactionTypeFilterSheet extends StatefulWidget {
  const TransactionTypeFilterSheet({
    required this.selected,
    required this.onApply,
    super.key,
  });

  final TransactionType? selected;
  final ValueChanged<TransactionType?> onApply;

  @override
  State<TransactionTypeFilterSheet> createState() =>
      _TransactionTypeFilterSheetState();
}

class _TransactionTypeFilterSheetState
    extends State<TransactionTypeFilterSheet> {
  late final _selected = ValueNotifier<TransactionType?>(widget.selected);

  /// Null is "All types".
  static const _options = <TransactionType?>[null, ...TransactionType.values];

  @override
  void dispose() {
    _selected.dispose();
    super.dispose();
  }

  void _pick(TransactionType? type) => _selected.value = type;

  void _reset() => _selected.value = null;

  void _apply() {
    widget.onApply(_selected.value);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x3_5,
      children: [
        ValueListenableBuilder(
          valueListenable: _selected,
          builder: (context, selected, _) => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _options.length,
            separatorBuilder: (_, _) => const SizedBox(height: MonAISpacing.x2),
            itemBuilder: (context, index) {
              final type = _options[index];
              return MonAIRadioOption(
                title: type?.label(l10n) ?? l10n.filterAllTypes,
                leading: _TypeIcon(type: type),
                selected: selected == type,
                onTap: () => _pick(type),
              );
            },
          ),
        ),
        Text(
          l10n.filterTransferNote,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colors.textTertiary,
          ),
        ),
        MonAISheetButtons(
          secondaryLabel: l10n.filterReset,
          onSecondary: _reset,
          primaryLabel: l10n.filterApply,
          onPrimary: _apply,
        ),
      ],
    );
  }
}

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.type});

  final TransactionType? type;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (icon, color) = switch (type) {
      null => (MonAIIcons.apps, c.textSecondary),
      .expense => (MonAIIcons.northEast, c.expense),
      .income => (MonAIIcons.southWest, c.income),
      .transfer => (MonAIIcons.swapHoriz, c.accent),
    };
    return MonAICategoryIcon(icon: icon, color: color);
  }
}
