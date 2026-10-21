import 'package:monai/features/home/presentation/pages/home/bloc/home_bloc.dart';
import 'package:monai/features/home/presentation/pages/home/model/home_budget_display.dart';

extension HomeStateX on HomeState {
  bool get hasCache => dashboard?.hasCache ?? false;

  bool get isFirstRun => recentLoaded && (dashboard?.recent.isEmpty ?? false);

  HomeBudgetDisplay get budgetDisplay => dashboard?.budget != null
      ? .progress
      : budgetLoaded
      ? .prompt
      : .hidden;

  bool get showWallets => (dashboard?.wallets.length ?? 0) > 1;

  bool get promptAddWallets => (dashboard?.wallets.length ?? 0) <= 1;
}
