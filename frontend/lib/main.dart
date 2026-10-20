import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/designsystem/theme/monai_theme.dart';
import 'package:monai/core/di/injector.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/network/session_manager.dart';
import 'package:monai/core/router/app_router.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/core/utils/extension/app_language_extension.dart';
import 'package:monai/core/utils/extension/app_theme_mode_extension.dart';
import 'package:monai/features/auth/domain/usecase/is_onboarding_completed_usecase.dart';
import 'package:monai/features/auth/domain/usecase/restore_session_usecase.dart';
import 'package:monai/features/auth/presentation/pages/session_expired/session_expired_gate.dart';
import 'package:monai/features/settings/presentation/app_settings/cubit/app_settings_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  // Restores before routing so the launch redirect sees the session. An
  // unreadable token leaves it signed out rather than blocking launch.
  await sl<RestoreSessionUseCase>()(const NoParams());
  // Read before the first frame, so the app never flashes the wrong theme.
  await sl<AppSettingsCubit>().load();
  final router = createAppRouter(
    sessionManager: sl<SessionManager>(),
    // An unreadable flag shows onboarding again rather than blocking launch.
    isOnboardingCompleted: () async =>
        (await sl<IsOnboardingCompletedUseCase>()(const NoParams()))
            .getOrElse((_) => false),
  );

  runApp(MyApp(router: router, appSettings: sl<AppSettingsCubit>()));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.router, required this.appSettings, super.key});

  final GoRouter router;

  /// The picked theme and language.
  final AppSettingsCubit appSettings;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: appSettings,
      child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (_, settings) => MaterialApp.router(
          onGenerateTitle: (context) => context.l10n.appTitle,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: settings.language.locale,
          theme: MonAITheme.light(),
          darkTheme: MonAITheme.dark(),
          themeMode: settings.themeMode.material,
          routerConfig: router,
          builder: (_, child) => SessionExpiredGate(child: child!),
        ),
      ),
    );
  }
}
