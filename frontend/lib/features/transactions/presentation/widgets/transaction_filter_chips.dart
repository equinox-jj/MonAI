import 'package:flutter/material.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/features/shared/domain/entity/transaction_filter.dart';
import 'package:monai/features/transactions/domain/entity/transaction_lookups.dart';
import 'package:monai/features/transactions/presentation/model/transaction_text.dart';

/// The filters a chip opens a sheet for.
enum TransactionFilterKind { month, wallet, category, type }

/// "All types", then Wallet, Category and Type, each named after its choice
/// once one is applied. Search shows its month first instead of "All types".
class TransactionFilterChips extends StatelessWidget {
  const TransactionFilterChips({
    required this.filter,
    required this.lookups,
    required this.onOpen,
    required this.onClearAll,
    super.key,
    this.monthLabel,
  });

  final TransactionFilter filter;
  final TransactionLookups lookups;
  final ValueChanged<TransactionFilterKind> onOpen;

  /// "All types": drops every filter.
  final VoidCallback onClearAll;

  /// Shows a month chip first with this label.
  final String? monthLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final chips = <_Chip>[
      if (monthLabel case final label?)
        _Chip(
          label: label,
          selected: false,
          kind: .month,
          hasDropdown: false,
          leadingIcon: MonAIIcons.calendarMonth,
        )
      else
        _Chip(
          label: l10n.filterAllTypes,
          selected: filter == const TransactionFilter(),
          hasDropdown: false,
        ),
      _Chip(
        label: lookups.wallet(filter.walletId)?.name ?? l10n.filterWallet,
        selected: filter.walletId != null,
        kind: .wallet,
      ),
      _Chip(
        label: lookups.category(filter.categoryId)?.name ?? l10n.filterCategory,
        selected: filter.categoryId != null,
        kind: .category,
      ),
      _Chip(
        label: filter.type?.label(l10n) ?? l10n.filterType,
        selected: filter.type != null,
        kind: .type,
      ),
    ];
    return SizedBox(
      height: MonAISizes.filterChip,
      child: ListView.separated(
        scrollDirection: .horizontal,
        padding: const .symmetric(horizontal: MonAISpacing.screenHorizontal),
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: MonAISpacing.x2),
        itemBuilder: (context, index) {
          final chip = chips[index];
          return MonAIFilterChip(
            label: chip.label,
            selected: chip.selected,
            hasDropdown: chip.hasDropdown,
            leadingIcon: chip.leadingIcon,
            onTap: switch (chip.kind) {
              final kind? => () => onOpen(kind),
              null => onClearAll,
            },
          );
        },
      ),
    );
  }
}

/// A chip; without a [kind] it is "All types".
class _Chip {
  const _Chip({
    required this.label,
    required this.selected,
    this.kind,
    this.hasDropdown = true,
    this.leadingIcon,
  });

  final String label;
  final bool selected;
  final TransactionFilterKind? kind;
  final bool hasDropdown;
  final MonAIIconData? leadingIcon;
}
