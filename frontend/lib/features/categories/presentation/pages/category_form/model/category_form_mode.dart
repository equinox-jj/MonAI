import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/category_type.dart';

part 'category_form_mode.freezed.dart';

/// Whether the form adds a category or edits one.
@freezed
sealed class CategoryFormMode with _$CategoryFormMode {
  /// A new category of [type].
  const factory CategoryFormMode.create(CategoryType type) = CreateCategoryMode;

  /// The category with [id].
  const factory CategoryFormMode.edit(String id) = EditCategoryMode;
}

/// How the form closed.
enum CategoryFormOutcome {
  /// Saved.
  saved,

  /// "Delete category": the list runs the delete.
  deleteRequested,
}
