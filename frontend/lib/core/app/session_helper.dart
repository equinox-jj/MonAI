import 'package:go_router/go_router.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/data/network/session_manager.dart';
import 'package:monai/app_router.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/auth/domain/usecase/is_onboarding_completed_usecase.dart';
import 'package:monai/features/auth/domain/usecase/restore_session_usecase.dart';
import 'package:monai/features/settings/presentation/app_settings/cubit/app_settings_cubit.dart';

abstract final class SessionHelper {
  const SessionHelper._();

  /// Call once before `runApp`, after `WidgetsFlutterBinding.ensureInitialized`.
  static Future<GoRouter> init() async {
    // Restores before routing so the launch redirect sees the session. An
    // unreadable token leaves it signed out rather than blocking launch.
    await sl<RestoreSessionUseCase>()(const NoParams());
    // Read before the first frame, so the app never flashes the wrong theme.
    await sl<AppSettingsCubit>().load();

    final isOnBoardingCompleted = await sl<IsOnboardingCompletedUseCase>()(
      const NoParams(),
    );

    return createAppRouter(
      sessionManager: sl<SessionManager>(),
      // An unreadable flag shows onboarding again rather than blocking launch.
      isOnboardingCompleted: () async =>
          isOnBoardingCompleted.getOrElse((_) => false),
    );
  }
}
