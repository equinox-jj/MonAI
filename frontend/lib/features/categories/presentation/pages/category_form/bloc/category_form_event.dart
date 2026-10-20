part of 'category_form_bloc.dart';

@freezed
sealed class CategoryFormEvent with _$CategoryFormEvent {
  /// The form opened.
  const factory CategoryFormEvent.started() = _Started;

  /// The name field's text changed.
  const factory CategoryFormEvent.nameEdited(String name) = _NameEdited;

  /// An icon in the grid, as a Material Symbols name.
  const factory CategoryFormEvent.iconPicked(String icon) = _IconPicked;

  /// A color swatch, as `#RRGGBB`.
  const factory CategoryFormEvent.colorPicked(String color) = _ColorPicked;

  /// Save, with the name field's text.
  const factory CategoryFormEvent.saveRequested(String name) = _SaveRequested;
}
