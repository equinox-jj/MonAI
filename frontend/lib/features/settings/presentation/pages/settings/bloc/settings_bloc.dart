import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/utils/month_format.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/settings/domain/entity/settings_overview.dart';
import 'package:monai/features/settings/domain/logic/settings_rules.dart';
import 'package:monai/features/settings/domain/usecase/get_app_version_usecase.dart';
import 'package:monai/features/settings/domain/usecase/refresh_settings_usecase.dart';
import 'package:monai/features/settings/domain/usecase/watch_settings_overview_usecase.dart';
import 'package:monai/features/shared/domain/usecase/logout_all_devices_usecase.dart';
import 'package:monai/features/shared/domain/usecase/logout_usecase.dart';

part 'settings_bloc.freezed.dart';
part 'settings_event.dart';
part 'settings_state.dart';

/// The Settings hub: shows the cache at once and refreshes the user, the
/// month's budget and the categories in the background; signs out here or
/// everywhere.
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  /// [now] is the clock; tests pass a fixed one.
  SettingsBloc({
    required this._watchOverview,
    required this._refresh,
    required this._getAppVersion,
    required this._logout,
    required this._logoutAllDevices,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now,
       super(const SettingsState()) {
    on<_Started>(_onStarted);
    on<_OverviewChanged>(_onOverviewChanged);
    on<_SignOutConfirmed>(_onSignOutConfirmed);
  }

  final WatchSettingsOverviewUseCase _watchOverview;
  final RefreshSettingsUseCase _refresh;
  final GetAppVersionUseCase _getAppVersion;
  final LogoutUseCase _logout;
  final LogoutAllDevicesUseCase _logoutAllDevices;
  final DateTime Function() _now;

  StreamSubscription<void>? _overview;

  Future<void> _onStarted(_Started event, Emitter<SettingsState> emit) async {
    final month = monthOf(_now());
    unawaited(_overview?.cancel());
    _overview = _watchOverview(month).listen(
      // A failed cache read keeps the last values on screen.
      (result) => result.match(
        (_) {},
        (overview) => add(SettingsEvent.overviewChanged(overview)),
      ),
    );
    unawaited(_refresh(month));
    final version = await _getAppVersion(const NoParams());
    emit(state.copyWith(appVersion: version.getOrElse((_) => '')));
  }

  void _onOverviewChanged(_OverviewChanged event, Emitter<SettingsState> emit) {
    emit(state.copyWith(overview: event.overview));
  }

  Future<void> _onSignOutConfirmed(
    _SignOutConfirmed event,
    Emitter<SettingsState> emit,
  ) async {
    if (state.isSigningOut) return;
    emit(state.copyWith(isSigningOut: true, signOutFailure: null));
    final result = event.allDevices
        ? await _logoutAllDevices(const NoParams())
        : await _logout(const NoParams());
    // On success the session ends and the router leaves for Sign in.
    emit(
      state.copyWith(
        isSigningOut: false,
        signOutFailure: result.getLeft().map(signOutFailureOf).toNullable(),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _overview?.cancel();
    return super.close();
  }
}
