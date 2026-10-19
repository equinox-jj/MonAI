import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/designsystem/theme/monai_theme.dart';
import 'package:monai/core/di/injector.dart';
import 'package:monai/core/l10n/l10n.dart';
import 'package:monai/core/network/session_manager.dart';
import 'package:monai/core/router/app_router.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/auth/domain/usecase/is_onboarding_completed_usecase.dart';
import 'package:monai/features/auth/domain/usecase/restore_session_usecase.dart';
import 'package:monai/features/auth/presentation/pages/session_expired/session_expired_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  // Restores before routing so the launch redirect sees the session. An
  // unreadable token leaves it signed out rather than blocking launch.
  await sl<RestoreSessionUseCase>()(const NoParams());
  final router = createAppRouter(
    sessionManager: sl<SessionManager>(),
    // An unreadable flag shows onboarding again rather than blocking launch.
    isOnboardingCompleted: () async =>
        (await sl<IsOnboardingCompletedUseCase>()(const NoParams()))
            .getOrElse((_) => false),
  );

  runApp(MyApp(router: router));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.router, super.key});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: MonAITheme.light(),
      darkTheme: MonAITheme.dark(),
      routerConfig: router,
      builder: (_, child) => SessionExpiredGate(child: child!),
    );
  }
}
