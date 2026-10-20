import 'package:flutter/foundation.dart';

/// Where the Wallets screen's buttons lead. The screen fills these in; the
/// sections only call them.
@immutable
class WalletsActions {
  const WalletsActions({
    required this.onAddWallet,
    required this.onOpenWallet,
    required this.onShowArchived,
    required this.onRetry,
  });

  final VoidCallback onAddWallet;
  final ValueChanged<String> onOpenWallet;
  final VoidCallback onShowArchived;
  final VoidCallback onRetry;
}
