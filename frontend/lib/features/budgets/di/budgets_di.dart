import 'package:monai/core/di/injector.dart';
import 'package:monai/features/budgets/domain/usecase/delete_budget_usecase.dart';
import 'package:monai/features/budgets/domain/usecase/set_budget_usecase.dart';
import 'package:monai/features/budgets/presentation/pages/budget/bloc/budget_bloc.dart';

class BudgetsDI {
  BudgetsDI._();

  static Future<void> init() async {
    sl
      ..registerFactory(() => SetBudgetUseCase(sl()))
      ..registerFactory(() => DeleteBudgetUseCase(sl()))
      ..registerFactoryParam<BudgetBloc, DateTime, void>(
        (month, _) => BudgetBloc(
          month: month,
          watchBudget: sl(),
          refreshBudget: sl(),
          watchReport: sl(),
          refreshReport: sl(),
          setBudget: sl(),
          deleteBudget: sl(),
        ),
      );
  }
}
