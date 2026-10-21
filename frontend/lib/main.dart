import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monai/core/ui/designsystem/theme/monai_theme.dart';
import 'package:monai/core/app/injector.dart';
import 'package:monai/core/ui/l10n/l10n.dart';
import 'package:monai/core/utils/extension/app_language_extension.dart';
import 'package:monai/core/utils/extension/app_theme_mode_extension.dart';
import 'package:monai/core/app/session_helper.dart';
import 'package:monai/features/auth/presentation/pages/session_expired/session_expired_gate.dart';
import 'package:monai/features/settings/presentation/app_settings/cubit/app_settings_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  final router = await SessionHelper.init();

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
          themeAnimationStyle: AnimationStyle.noAnimation,
          routerConfig: router,
          builder: (_, child) => SessionExpiredGate(child: child!),
        ),
      ),
    );
  }
}
