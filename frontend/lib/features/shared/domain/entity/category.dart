import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/category_type.dart';

part 'category.freezed.dart';

/// A group of expenses or incomes. Hidden categories stay on old
/// transactions but are left out of pickers.
@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    required CategoryType type,
    required bool isDefault,
    required bool isSystem,
    required bool isHidden,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? icon,

    /// `#RRGGBB`.
    String? color,
  }) = _Category;
}
