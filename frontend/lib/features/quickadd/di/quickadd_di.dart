import 'package:monai/core/di/injector.dart';
import 'package:monai/features/quickadd/data/datasources/quickadd_local_datasource.dart';
import 'package:monai/features/quickadd/data/datasources/quickadd_remote_datasource.dart';
import 'package:monai/features/quickadd/data/repository/quickadd_repository_impl.dart';
import 'package:monai/features/quickadd/domain/repository/quickadd_repository.dart';
import 'package:monai/features/quickadd/domain/usecase/complete_drafts_with_ai_usecase.dart';
import 'package:monai/features/quickadd/domain/usecase/read_quick_add_phrase_usecase.dart';
import 'package:monai/features/quickadd/domain/usecase/save_quick_add_draft_usecase.dart';
import 'package:monai/features/quickadd/domain/usecase/watch_quick_add_context_usecase.dart';
import 'package:monai/features/quickadd/presentation/model/quick_add_review_args.dart';
import 'package:monai/features/quickadd/presentation/pages/quick_add/bloc/quick_add_bloc.dart';
import 'package:monai/features/quickadd/presentation/pages/quick_add_review/bloc/quick_add_review_bloc.dart';

class QuickaddDI {
  QuickaddDI._();

  static Future<void> init() async {
    sl
      ..registerLazySingleton<QuickaddRemoteDataSource>(
        () => QuickaddRemoteDataSourceImpl(dio: sl()),
      )
      ..registerLazySingleton<QuickaddLocalDataSource>(
        () => QuickaddLocalDataSourceImpl(dao: sl()),
      )
      ..registerLazySingleton<QuickaddRepository>(
        () => QuickaddRepositoryImpl(remote: sl(), local: sl()),
      )
      ..registerFactory(
        () => WatchQuickAddContextUseCase(
          wallets: sl(),
          categories: sl(),
          providers: sl(),
        ),
      )
      ..registerFactory(() => ReadQuickAddPhraseUseCase(sl()))
      ..registerFactory(
        () => CompleteDraftsWithAiUseCase(repository: sl(), watchUser: sl()),
      )
      ..registerFactory(() => SaveQuickAddDraftUseCase(sl()))
      ..registerFactory(
        () => QuickAddBloc(watchContext: sl(), read: sl(), complete: sl()),
      )
      ..registerFactoryParam<QuickAddReviewBloc, QuickAddReviewArgs, void>(
        (args, _) => QuickAddReviewBloc(
          args: args,
          save: sl(),
          watchWallets: sl(),
          watchCategories: sl(),
        ),
      );
  }
}
