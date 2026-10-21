part of 'manage_providers_bloc.dart';

@freezed
abstract class ManageProvidersState with _$ManageProvidersState {
  const factory ManageProvidersState({
    @Default(UiStatus.initial) UiStatus status,
    @Default([]) List<AdminPaymentProvider> providers,
    @Default('') String query,
    @Default(false) bool isRefreshing,
    ProviderFailure? loadFailure,
    ProviderFailure? refreshFailure,
    @Default(false) bool canCreate,
    @Default(false) bool canEdit,
  }) = _ManageProvidersState;
}
