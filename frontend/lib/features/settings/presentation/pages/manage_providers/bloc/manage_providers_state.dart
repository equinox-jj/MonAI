part of 'manage_providers_bloc.dart';

@freezed
abstract class ManageProvidersState with _$ManageProvidersState {
  const factory ManageProvidersState({
    /// [UiStatus.loading] until the first load lands; [UiStatus.failure]
    /// when it failed and nothing is shown.
    @Default(UiStatus.initial) UiStatus status,

    /// Every provider, by sort order.
    @Default([]) List<AdminPaymentProvider> providers,
    @Default('') String query,

    /// A pull-to-refresh is running over a shown list.
    @Default(false) bool isRefreshing,

    /// Why the first load failed.
    ProviderFailure? loadFailure,

    /// Why a reload over a shown list failed; shown once as a message.
    ProviderFailure? refreshFailure,

    /// The user may add providers.
    @Default(false) bool canCreate,

    /// The user may open a provider to change it.
    @Default(false) bool canEdit,
  }) = _ManageProvidersState;
}

extension ManageProvidersStateX on ManageProvidersState {
  /// The providers matching [ManageProvidersState.query].
  List<AdminPaymentProvider> get shown => filterProviders(providers, query);
}
