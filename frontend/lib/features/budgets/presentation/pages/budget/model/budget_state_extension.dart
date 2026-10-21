import 'package:monai/features/budgets/domain/logic/budget_preview.dart';
import 'package:monai/features/budgets/presentation/pages/budget/bloc/budget_bloc.dart';

extension BudgetStateX on BudgetState {
  bool get hasBudget => budget != null;

  bool get isBusy => isSaving || isDeleting;

  int get spent => budget?.spent ?? reportSpent ?? 0;

  BudgetPreview? get preview => BudgetPreview.of(limit: limit, spent: spent);

  bool get canSave => limit > 0 && !isBusy;
}
