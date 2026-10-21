import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/usecase/usecase.dart';
import 'package:monai/features/settings/domain/entity/admin_payment_provider.dart';
import 'package:monai/features/settings/domain/logic/provider_rules.dart';
import 'package:monai/features/settings/domain/usecase/get_admin_providers_usecase.dart';
import 'package:monai/features/settings/domain/usecase/watch_provider_changes_usecase.dart';
import 'package:monai/features/settings/presentation/model/provider_failure.dart';
import 'package:monai/features/shared/domain/entity/user.dart';
import 'package:monai/features/shared/domain/usecase/watch_user_usecase.dart';

part 'manage_providers_bloc.freezed.dart';
part 'manage_providers_event.dart';
part 'manage_providers_state.dart';

/// The provider catalog for admins, inactive providers included, searchable
/// by name or alias. Reloads whenever a provider is saved or deleted
/// elsewhere. The list is network only, so it lives in the state.
class ManageProvidersBloc
    extends Bloc<ManageProvidersEvent, ManageProvidersState> {
  ManageProvidersBloc({
    required this._watchUser,
    required this._getProviders,
    required this._watchChanges,
  }) : super(const ManageProvidersState()) {
    on<_Started>(_onStarted);
    on<_UserChanged>(_onUserChanged);
    on<_QueryChanged>(_onQueryChanged);
    on<_Refreshed>(_onRefreshed);
  }

  final WatchUserUseCase _watchUser;
  final GetAdminProvidersUseCase _getProviders;
  final WatchProviderChangesUseCase _watchChanges;

  StreamSubscription<void>? _user;
  StreamSubscription<void>? _changes;

  /// Counts loads, so only the latest one's result lands.
  int _load = 0;

  Future<void> _onStarted(
    _Started event,
    Emitter<ManageProvidersState> emit,
  ) async {
    unawaited(_user?.cancel());
    unawaited(_changes?.cancel());
    _user = _watchUser(const NoParams()).listen(
      // A failed cache read keeps the last permissions.
      (result) => result.match(
        (_) {},
        (user) => add(ManageProvidersEvent.userChanged(user)),
      ),
    );
    _changes = _watchChanges(const NoParams())
        .listen((_) => add(const ManageProvidersEvent.refreshed(quiet: true)));
    await _reload(emit, userInitiated: false);
  }

  void _onUserChanged(_UserChanged event, Emitter<ManageProvidersState> emit) {
    emit(
      state.copyWith(
        canCreate: canCreateProviders(event.user),
        canEdit: canEditProviders(event.user),
      ),
    );
  }

  void _onQueryChanged(
    _QueryChanged event,
    Emitter<ManageProvidersState> emit,
  ) {
    emit(state.copyWith(query: event.query));
  }

  Future<void> _onRefreshed(
    _Refreshed event,
    Emitter<ManageProvidersState> emit,
  ) => _reload(emit, userInitiated: !event.quiet);

  /// Loads the list. A list already on screen stays while it loads, and a
  /// failure then shows as a message instead of the error state.
  Future<void> _reload(
    Emitter<ManageProvidersState> emit, {
    required bool userInitiated,
  }) async {
    final load = ++_load;
    final hasList = state.status == .success;
    emit(
      state.copyWith(
        status: hasList ? .success : .loading,
        isRefreshing: hasList && userInitiated,
        loadFailure: null,
        refreshFailure: null,
      ),
    );
    final result = await _getProviders(const NoParams());
    if (load != _load) return;
    emit(
      result.match(
        (failure) => hasList
            ? state.copyWith(
                isRefreshing: false,
                refreshFailure: ProviderFailure.of(failure),
              )
            : state.copyWith(
                status: .failure,
                loadFailure: ProviderFailure.of(failure),
              ),
        (providers) => state.copyWith(
          status: .success,
          isRefreshing: false,
          providers: providers,
        ),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _user?.cancel();
    await _changes?.cancel();
    return super.close();
  }
}
