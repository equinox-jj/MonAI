import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/base/error/failure.dart';
import 'package:monai/core/base/error/field_error.dart';
import 'package:monai/core/model/category_type.dart';
import 'package:monai/core/model/ui_status.dart';
import 'package:monai/features/categories/domain/logic/category_choices.dart';
import 'package:monai/features/categories/domain/usecase/create_category_usecase.dart';
import 'package:monai/features/categories/domain/usecase/find_category_usecase.dart';
import 'package:monai/features/categories/domain/usecase/update_category_usecase.dart';
import 'package:monai/features/categories/domain/validation/category_input_validator.dart';
import 'package:monai/features/categories/presentation/model/category_failure.dart';
import 'package:monai/features/categories/presentation/pages/category_form/model/category_form_mode.dart';
import 'package:monai/features/shared/domain/entity/category.dart';
import 'package:monai/features/shared/domain/entity/category_input.dart';

part 'category_form_bloc.freezed.dart';
part 'category_form_event.dart';
part 'category_form_state.dart';

class CategoryFormBloc extends Bloc<CategoryFormEvent, CategoryFormState> {
  CategoryFormBloc({
    required CategoryFormMode mode,
    required this._find,
    required this._create,
    required this._update,
  }) : super(
         CategoryFormState(
           mode: mode,
           type: switch (mode) {
             CreateCategoryMode(:final type) => type,
             EditCategoryMode() => CategoryType.expense,
           },
           status: mode is CreateCategoryMode
               ? UiStatus.success
               : UiStatus.initial,
         ),
       ) {
    on<_Started>(_onStarted);
    on<_NameEdited>(_onNameEdited);
    on<_IconPicked>(_onIconPicked);
    on<_ColorPicked>(_onColorPicked);
    on<_SaveRequested>(_onSaveRequested);
  }

  final FindCategoryUseCase _find;
  final CreateCategoryUseCase _create;
  final UpdateCategoryUseCase _update;

  Future<void> _onStarted(
    _Started event,
    Emitter<CategoryFormState> emit,
  ) async {
    final mode = state.mode;
    if (mode is! EditCategoryMode) return;
    emit(state.copyWith(status: UiStatus.loading));
    final result = await _find(mode.id);
    switch (result) {
      case Right(value: final category?):
        emit(
          state.copyWith(
            status: UiStatus.success,
            original: category,
            type: category.type,
            icon: categoryIconChoice(category.icon),
            color: categoryColorChoice(category.color),
          ),
        );
      case Right(value: null):
        emit(state.copyWith(done: true, actionFailure: .notFound));
      case Left(value: final failure):
        emit(
          state.copyWith(
            done: true,
            actionFailure: CategoryFailure.of(failure),
          ),
        );
    }
  }

  void _onNameEdited(_NameEdited event, Emitter<CategoryFormState> emit) =>
      emit(
        state.copyWith(
          nameError: state.autovalidate
              ? CategoryInputValidator.name(event.name)
              : null,
        ),
      );

  void _onIconPicked(_IconPicked event, Emitter<CategoryFormState> emit) =>
      emit(state.copyWith(icon: event.icon));

  void _onColorPicked(_ColorPicked event, Emitter<CategoryFormState> emit) =>
      emit(state.copyWith(color: event.color));

  Future<void> _onSaveRequested(
    _SaveRequested event,
    Emitter<CategoryFormState> emit,
  ) async {
    if (state.isSaving || state.status != UiStatus.success) return;
    emit(state.copyWith(isSaving: true, nameError: null, actionFailure: null));
    final input = CategoryInput(
      name: event.name,
      type: state.type,
      icon: state.icon,
      color: state.color,
    );
    final result = switch (state.original) {
      final original? => await _update((original: original, input: input)),
      null => await _create(input),
    };
    switch (result) {
      case Right():
        emit(state.copyWith(isSaving: false, done: true));
      case Left(value: final failure):
        emit(_failed(state.copyWith(isSaving: false), failure));
    }
  }

  CategoryFormState _failed(CategoryFormState state, Failure failure) {
    final nameError = switch (failure) {
      ValidationFailure(:final fieldErrors) => fieldErrors.firstForField(
        CategoryInputValidator.nameField,
      ),
      ConflictFailure() => const FieldError(
        field: CategoryInputValidator.nameField,
        code: 'conflict',
        message: 'Category name already exists',
      ),
      _ => null,
    };
    if (nameError != null) {
      return state.copyWith(nameError: nameError, autovalidate: true);
    }
    return state.copyWith(actionFailure: CategoryFailure.of(failure));
  }
}
