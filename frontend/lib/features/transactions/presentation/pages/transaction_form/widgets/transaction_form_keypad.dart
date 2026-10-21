import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monai/core/ui/designsystem/designsystem.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/features/transactions/presentation/pages/transaction_form/bloc/transaction_form_bloc.dart';

/// 1 to 9, then 000, 0 and backspace.
class TransactionFormKeypad extends StatelessWidget {
  const TransactionFormKeypad({super.key});

  static const _keyHeight = 52.0;

  /// Null is backspace; -1 is "000".
  static const _keys = <int?>[1, 2, 3, 4, 5, 6, 7, 8, 9, -1, 0, null];

  void _press(BuildContext context, int? key) {
    final bloc = context.read<TransactionFormBloc>();
    bloc.add(switch (key) {
      null => const TransactionFormEvent.backspacePressed(),
      -1 => const TransactionFormEvent.tripleZeroPressed(),
      final digit => TransactionFormEvent.digitPressed(digit),
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: .zero,
      itemCount: _keys.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: MonAISpacing.x1_5,
        crossAxisSpacing: MonAISpacing.x1_5,
        mainAxisExtent: _keyHeight,
      ),
      itemBuilder: (context, index) {
        final key = _keys[index];
        return _Key(keyValue: key, onPressed: () => _press(context, key));
      },
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.keyValue, required this.onPressed});

  final int? keyValue;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final style = context.textTheme.headlineSmall?.copyWith(
      color: c.textPrimary,
    );
    return Material(
      color: c.background,
      borderRadius: MonAIRadius.lgAll,
      clipBehavior: .antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Center(
          child: switch (keyValue) {
            null => MonAIIcon(
              MonAIIcons.backspace,
              color: c.textPrimary,
              semanticLabel: context.l10n.transactionFormDeleteDigit,
            ),
            -1 => Text('000', style: style),
            final digit => Text('$digit', style: style),
          },
        ),
      ),
    );
  }
}
