part of 'category_form_bloc.dart';

@freezed
sealed class CategoryFormEvent with _$CategoryFormEvent {
  const factory CategoryFormEvent.started() = _Started;
  const factory CategoryFormEvent.nameEdited(String name) = _NameEdited;
  const factory CategoryFormEvent.iconPicked(String icon) = _IconPicked;
  const factory CategoryFormEvent.colorPicked(String color) = _ColorPicked;
  const factory CategoryFormEvent.saveRequested(String name) = _SaveRequested;
}
