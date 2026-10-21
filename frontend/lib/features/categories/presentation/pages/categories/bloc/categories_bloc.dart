import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/core/base/usecase.dart';
import 'package:monai/features/categories/domain/logic/category_rules.dart';
import 'package:monai/features/categories/domain/usecase/delete_category_usecase.dart';
import 'package:monai/features/categories/domain/usecase/set_category_hidden_usecase.dart';
import 'package:monai/features/categories/presentation/model/category_failure.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/usecase/refresh_categories_usecase.dart';
import 'package:monai/features/shared/domain/usecase/watch_categories_usecase.dart';
import 'package:monai/features/categories/presentation/pages/categories/model/categories_state_extension.dart';

part 'categories_bloc.freezed.dart';
part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc({
    required this._watchCategories,
    required this._refreshCategories,
    required this._setHidden,
    required this._delete,
  }) : super(const CategoriesState()) {
    on<_Started>(_onStarted);
    on<_TypeSelected>(_onTypeSelected);
    on<_Retried>(_onRetried);
    on<_HiddenToggled>(_onHiddenToggled);
    on<_DeleteRequested>(_onDeleteRequested);
    on<_CategoriesChanged>(_onCategoriesChanged);
  }

  final WatchCategoriesUseCase _watchCategories;
  final RefreshCategoriesUseCase _refreshCategories;
  final SetCategoryHiddenUseCase _setHidden;
  final DeleteCategoryUseCase _delete;

  StreamSubscription<void>? _categories;

  Future<void> _onStarted(_Started event, Emitter<CategoriesState> emit) async {
    _categories = _watchCategories(const NoParams()).listen(
      (result) => result.match(
        (_) {},
        (categories) => add(CategoriesEvent.categoriesChanged(categories)),
      ),
    );
    await _refresh(emit);
  }

  Future<void> _onRetried(_Retried event, Emitter<CategoriesState> emit) =>
      _refresh(emit);

  Future<void> _refresh(Emitter<CategoriesState> emit) async {
    if (state.categories.isEmpty) {
      emit(state.copyWith(status: UiStatus.loading, loadFailure: null));
    }
    final result = await _refreshCategories(const NoParams());
    switch (result) {
      case Right():
        emit(state.copyWith(status: UiStatus.success, loadFailure: null));
      // Saved categories stay on screen when a refresh fails.
      case Left() when state.categories.isNotEmpty:
        emit(state.copyWith(status: UiStatus.success));
      case Left(value: final failure):
        emit(
          state.copyWith(
            status: UiStatus.failure,
            loadFailure: CategoryFailure.of(failure),
          ),
        );
    }
  }

  void _onCategoriesChanged(
    _CategoriesChanged event,
    Emitter<CategoriesState> emit,
  ) {
    if (event.categories.isEmpty && state.status != UiStatus.success) {
      return;
    }
    emit(
      state.copyWith(
        categories: event.categories,
        status: UiStatus.success,
        loadFailure: null,
      ),
    );
  }

  void _onTypeSelected(_TypeSelected event, Emitter<CategoriesState> emit) =>
      emit(state.copyWith(type: event.type));

  Future<void> _onHiddenToggled(
    _HiddenToggled event,
    Emitter<CategoriesState> emit,
  ) async {
    final category = state.byId(event.id);
    if (category == null ||
        !category.canToggleHidden ||
        state.busyIds.contains(event.id)) {
      return;
    }
    emit(
      state.copyWith(
        busyIds: {...state.busyIds, event.id},
        actionFailure: null,
      ),
    );
    final result = await _setHidden((id: event.id, hidden: !category.isHidden));
    emit(
      state.copyWith(
        busyIds: {...state.busyIds}..remove(event.id),
        actionFailure: result.match(CategoryFailure.of, (_) => null),
      ),
    );
  }

  Future<void> _onDeleteRequested(
    _DeleteRequested event,
    Emitter<CategoriesState> emit,
  ) async {
    final category = state.byId(event.id);
    if (category == null ||
        !category.canDelete ||
        state.busyIds.contains(event.id)) {
      return;
    }
    emit(
      state.copyWith(
        busyIds: {...state.busyIds, event.id},
        moveFrom: null,
        deleted: null,
        actionFailure: null,
      ),
    );
    final result = await _delete((id: event.id, moveTo: event.moveTo));
    final busyIds = {...state.busyIds}..remove(event.id);
    switch (result) {
      case Right():
        emit(state.copyWith(busyIds: busyIds, deleted: category));
      case Left(value: final failure)
          when failure.code == DeleteCategoryUseCase.hasTransactionsCode:
        emit(state.copyWith(busyIds: busyIds, moveFrom: category));
      case Left(value: final failure):
        emit(
          state.copyWith(
            busyIds: busyIds,
            actionFailure: CategoryFailure.of(failure),
          ),
        );
    }
  }

  @override
  Future<void> close() async {
    await _categories?.cancel();
    return super.close();
  }
}
