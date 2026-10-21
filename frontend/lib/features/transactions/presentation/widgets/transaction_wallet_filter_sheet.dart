import 'package:flutter/material.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/extension/wallet_type_extension.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/transactions/presentation/widgets/transaction_wallet_avatar.dart';

class TransactionWalletFilterSheet extends StatefulWidget {
  const TransactionWalletFilterSheet({
    required this.wallets,
    required this.selectedId,
    required this.onApply,
    super.key,
  });

  final List<Wallet> wallets;
  final String? selectedId;
  final ValueChanged<String?> onApply;

  @override
  State<TransactionWalletFilterSheet> createState() =>
      _TransactionWalletFilterSheetState();
}

class _TransactionWalletFilterSheetState
    extends State<TransactionWalletFilterSheet> {
  late final _selected = ValueNotifier<String?>(widget.selectedId);

  @override
  void dispose() {
    _selected.dispose();
    super.dispose();
  }

  void _pick(String? id) => _selected.value = id;

  void _clear() => _selected.value = null;

  void _apply() {
    widget.onApply(_selected.value);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ValueListenableBuilder(
      valueListenable: _selected,
      builder: (context, selected, _) => Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        spacing: MonAISpacing.x3_5,
        children: [
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: widget.wallets.length + 1,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: MonAISpacing.x2),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return MonAIRadioOption(
                    title: l10n.filterAllWallets,
                    selected: selected == null,
                    onTap: () => _pick(null),
                  );
                }
                final wallet = widget.wallets[index - 1];
                return Opacity(
                  opacity: wallet.isArchived ? 0.75 : 1,
                  child: MonAIRadioOption(
                    title: wallet.name,
                    subtitle: wallet.isArchived
                        ? l10n.filterArchived
                        : wallet.type.label(l10n),
                    leading: TransactionWalletAvatar(wallet: wallet),
                    selected: selected == wallet.id,
                    onTap: () => _pick(wallet.id),
                  ),
                );
              },
            ),
          ),
          MonAISheetButtons(
            secondaryLabel: l10n.filterClear,
            onSecondary: _clear,
            primaryLabel: selected == null
                ? l10n.filterShowAll
                : l10n.filterApply,
            onPrimary: _apply,
          ),
        ],
      ),
    );
  }
}
