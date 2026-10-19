import 'package:flutter/material.dart';

import 'package:monai/core/designsystem/gallery/design_system_gallery_page.dart';
import 'package:monai/core/designsystem/theme/monai_theme.dart';
import 'package:monai/core/di/injector.dart';
import 'package:monai/core/l10n/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: MonAITheme.light(),
      darkTheme: MonAITheme.dark(),
      // The design-system gallery stands in until the router exists.
      home: const DesignSystemGalleryPage(),
    );
  }
}
