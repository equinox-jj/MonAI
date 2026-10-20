import 'package:flutter/material.dart';
import 'package:monai/core/designsystem/designsystem.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/utils/money_format.dart';
import 'package:monai/features/shared/domain/entity/wallet.dart';
import 'package:monai/features/transactions/presentation/widgets/transaction_wallet_avatar.dart';

/// The wallets with their balances; Done sends the pick to [onPick] and
/// closes. Show it with [showMonAIBottomSheet].
class TransactionWalletPickerSheet extends StatefulWidget {
  const TransactionWalletPickerSheet({
    required this.wallets,
    required this.selectedId,
    required this.onPick,
    super.key,
  });

  final List<Wallet> wallets;
  final String? selectedId;
  final ValueChanged<String> onPick;

  @override
  State<TransactionWalletPickerSheet> createState() =>
      _TransactionWalletPickerSheetState();
}

class _TransactionWalletPickerSheetState
    extends State<TransactionWalletPickerSheet> {
  late final _selected = ValueNotifier<String?>(widget.selectedId);

  @override
  void dispose() {
    _selected.dispose();
    super.dispose();
  }

  void _pick(String id) => _selected.value = id;

  void _done() {
    if (_selected.value case final id?) widget.onPick(id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // TODO(transactions): add "New wallet" once the wallet form exists.
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      spacing: MonAISpacing.x3_5,
      children: [
        Flexible(
          child: ValueListenableBuilder(
            valueListenable: _selected,
            builder: (context, selected, _) => ListView.separated(
              shrinkWrap: true,
              itemCount: widget.wallets.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: MonAISpacing.x2),
              itemBuilder: (context, index) {
                final wallet = widget.wallets[index];
                return MonAIRadioOption(
                  title: wallet.name,
                  subtitle: formatRupiah(wallet.currentBalance),
                  tag: wallet.isDefault ? l10n.transactionFormDefault : null,
                  leading: TransactionWalletAvatar(wallet: wallet),
                  selected: selected == wallet.id,
                  onTap: () => _pick(wallet.id),
                );
              },
            ),
          ),
        ),
        Text(
          widget.wallets.isEmpty
              ? l10n.transactionFormNoWallets
              : l10n.transactionFormArchivedNote,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colors.textTertiary,
          ),
        ),
        MonAIButton(
          label: l10n.transactionFormDone,
          onPressed: _done,
          expand: true,
        ),
      ],
    );
  }
}
