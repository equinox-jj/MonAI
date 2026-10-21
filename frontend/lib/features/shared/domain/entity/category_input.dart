import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/core/model/category_type.dart';

part 'category_input.freezed.dart';

@freezed
abstract class CategoryInput with _$CategoryInput {
  const factory CategoryInput({
    required String name,
    required CategoryType type,

    /// A Material Symbols name, e.g. `local_cafe`.
    String? icon,

    /// `#RRGGBB`.
    String? color,
  }) = _CategoryInput;

  const CategoryInput._();

  CategoryInput get normalized => copyWith(name: name.trim());
}
