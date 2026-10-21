import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_changes.freezed.dart';

/// Null leaves a field as it is. The type can't change.
@freezed
abstract class CategoryChanges with _$CategoryChanges {
  const factory CategoryChanges({
    String? name,
    String? icon,
    String? color,
    bool? isHidden,
  }) = _CategoryChanges;

  const CategoryChanges._();

  bool get isEmpty =>
      name == null && icon == null && color == null && isHidden == null;
}
