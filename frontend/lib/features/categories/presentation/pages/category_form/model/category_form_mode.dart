import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/category_type.dart';

part 'category_form_mode.freezed.dart';

@freezed
sealed class CategoryFormMode with _$CategoryFormMode {
  const factory CategoryFormMode.create(CategoryType type) = CreateCategoryMode;
  const factory CategoryFormMode.edit(String id) = EditCategoryMode;
}

enum CategoryFormOutcome { saved, deleteRequested }
