import 'package:flutter/foundation.dart';

/// Where the wallet screen's buttons lead. The screen fills these in; the
/// sections only call them.
@immutable
class WalletDetailActions {
  const WalletDetailActions({
    required this.onEdit,
    required this.onTransfer,
    required this.onArchive,
    required this.onOpenTransaction,
    required this.onRetry,
  });

  final VoidCallback onEdit;
  final VoidCallback onTransfer;
  final VoidCallback onArchive;
  final ValueChanged<String> onOpenTransaction;
  final VoidCallback onRetry;
}
