import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/app_language.dart';
import 'package:monai/core/model/app_theme_mode.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/settings/domain/usecase/get_language_usecase.dart';
import 'package:monai/features/settings/domain/usecase/get_theme_mode_usecase.dart';
import 'package:monai/features/settings/domain/usecase/set_language_usecase.dart';
import 'package:monai/features/settings/domain/usecase/set_theme_mode_usecase.dart';

part 'app_settings_cubit.freezed.dart';
part 'app_settings_state.dart';

/// The theme and language the whole app is drawn in. Lives as long as the
/// app: `MyApp` builds the [MaterialApp] from it, and Settings changes it.
class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit({
    required this._getThemeMode,
    required this._setThemeMode,
    required this._getLanguage,
    required this._setLanguage,
  }) : super(const AppSettingsState());

  final GetThemeModeUseCase _getThemeMode;
  final SetThemeModeUseCase _setThemeMode;
  final GetLanguageUseCase _getLanguage;
  final SetLanguageUseCase _setLanguage;

  /// Reads the saved picks. An unreadable one keeps following the device.
  Future<void> load() async {
    final themeMode = await _getThemeMode(const NoParams());
    final language = await _getLanguage(const NoParams());

    emit(
      AppSettingsState(
        themeMode: themeMode.getOrElse((_) => AppThemeMode.system),
        language: language.getOrElse((_) => AppLanguage.system),
      ),
    );
  }

  /// Switches the theme at once, then saves it. A failed save keeps it for
  /// this run only.
  Future<void> themeModePicked(AppThemeMode mode) async {
    if (mode == state.themeMode) return;
    emit(state.copyWith(themeMode: mode));
    await _setThemeMode(mode);
  }

  /// Switches the language at once, then saves it. A failed save keeps it
  /// for this run only.
  Future<void> languagePicked(AppLanguage language) async {
    if (language == state.language) return;
    emit(state.copyWith(language: language));
    await _setLanguage(language);
  }
}
