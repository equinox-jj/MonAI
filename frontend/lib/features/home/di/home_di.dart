import 'package:monai/core/di/injector.dart';
import 'package:monai/features/home/domain/usecase/refresh_home_usecase.dart';
import 'package:monai/features/home/domain/usecase/watch_home_dashboard_usecase.dart';
import 'package:monai/features/home/presentation/pages/home/bloc/home_bloc.dart';

class HomeDI {
  HomeDI._();

  static Future<void> init() async {
    sl
      ..registerFactory(
        () => WatchHomeDashboardUseCase(
          user: sl(),
          wallets: sl(),
          categories: sl(),
          recent: sl(),
          budget: sl(),
          report: sl(),
        ),
      )
      ..registerFactory(
        () => RefreshHomeUseCase(
          user: sl(),
          wallets: sl(),
          categories: sl(),
          recent: sl(),
          budget: sl(),
          report: sl(),
        ),
      )
      ..registerFactory(() => HomeBloc(watchDashboard: sl(), refresh: sl()));
  }
}
