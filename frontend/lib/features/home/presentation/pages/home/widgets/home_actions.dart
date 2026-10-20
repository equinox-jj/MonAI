import 'package:flutter/foundation.dart';

/// Where Home's buttons and links lead. The screen fills these in; the
/// sections only call them.
@immutable
class HomeActions {
  const HomeActions({
    required this.onSearch,
    required this.onProfile,
    required this.onQuickAdd,
    required this.onScanReceipt,
    required this.onSeeAllWallets,
    required this.onOpenWallet,
    required this.onAddWallet,
    required this.onOpenBudget,
    required this.onOpenReport,
    required this.onSeeAllTransactions,
    required this.onOpenTransaction,
    required this.onAddTransaction,
    required this.onToggleBalance,
    required this.onRetry,
  });

  final VoidCallback onSearch;
  final VoidCallback onProfile;
  final VoidCallback onQuickAdd;
  final VoidCallback onScanReceipt;
  final VoidCallback onSeeAllWallets;
  final ValueChanged<String> onOpenWallet;
  final VoidCallback onAddWallet;
  final VoidCallback onOpenBudget;
  final VoidCallback onOpenReport;
  final VoidCallback onSeeAllTransactions;
  final ValueChanged<String> onOpenTransaction;
  final VoidCallback onAddTransaction;
  final VoidCallback onToggleBalance;
  final VoidCallback onRetry;
}
